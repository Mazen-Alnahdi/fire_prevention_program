import 'dart:math';

class FireWeatherIndex {
  // Previous moisture value for Kuwait's arid climate
  double ffmcPrev = 85.0; // Starting with a drier condition base
  double dmcPrev = 30.0; // Higher initial value for Kuwait's climate
  double dcPrev = 300.0; // Higher drought code initial value

  double _calcFFMC(double temp, double rh, double wind, double rain) {
    double mo, rf, mr, ed, ew, ko, kd, kl, kw, m;

    // Calculate initial mo value with adjusted previous FFMC
    mo = 147.2 * (101 - ffmcPrev) / (59.5 + ffmcPrev);

    // Adjust rain threshold for Kuwait's rare rainfall
    if (rain > 0.3) {
      // Lowered from 0.5
      rf = rain - 0.3;
      if (mo <= 150) {
        mr = mo + 42.5 * rf * (exp(-100 / (251 - mo))) * (1 - exp(-6.93 / rf));
      } else {
        mr = mo +
            42.5 * rf * (exp(-100 / (251 - mo))) * (1 - exp(-6.93 / rf)) +
            0.0015 * (mo - 150) * (mo - 150) * pow(rf, 0.5);
      }
      if (mr > 250) mr = 250;
      mo = mr;
    }

    // Adjusted for Kuwait's high temperatures
    ed = 0.942 * pow(rh, 0.45) + // More sensitive to low humidity
        11 * exp((rh - 100) / 10) +
        0.18 *
            (40 - temp) *
            (1 - exp(-0.115 * rh)); // Adjusted base temp to 40°C

    if (mo > ed) {
      ko = 0.424 * (1 - pow(rh / 100, 1.7)) +
          0.0694 * pow(wind, 0.5) * (1 - pow(rh / 100, 8));
      kd = ko * 0.581 * exp(0.0365 * temp);
      m = ed + (mo - ed) * pow(10, -kd);
    } else {
      ew = 0.618 * pow(rh, 0.753) +
          10 * exp((rh - 100) / 10) +
          0.18 * (40 - temp) * (1 - exp(-0.115 * rh));

      if (mo < ew) {
        kl = 0.424 * (1 - pow((100 - rh) / 100, 1.7)) +
            0.0694 * pow(wind, 0.5) * (1 - pow((100 - rh) / 100, 8));
        kw = kl * 0.581 * exp(0.0365 * temp);
        m = ew - (ew - mo) * pow(10, -kw);
      } else {
        m = mo;
      }
    }

    ffmcPrev = 59.5 * (250 - m) / (147.2 + m);
    return ffmcPrev;
  }

  double _calcDMC(double temp, double rh, double rain, double lat) {
    double re = 0;
    double mo, mr, k, b = 0, pr, dl;

    if (rain > 1.0) {
      // Lowered from 1.5 for Kuwait's climate
      re = 0.92 * rain - 1.27;
      mo = 20 + exp(5.6348 - dmcPrev / 43.43);

      if (dmcPrev <= 33) {
        b = 100 / (0.5 + 0.3 * dmcPrev);
      } else if (dmcPrev <= 65) {
        b = 14 - 1.3 * log(dmcPrev);
      } else {
        b = 6.2 * log(dmcPrev) - 17.2;
      }

      mr = mo + 1000 * re / (48.77 + b * re);
      pr = 244.72 - 43.43 * log(mr - 20);

      if (pr > 0) {
        dmcPrev = pr;
      } else {
        dmcPrev = 0;
      }
    }

    if (temp > -1.1) {
      dl = _dayLength(lat, _currentMonth());
      k = 2.5 *
          (temp + 1.1) *
          (100 - rh) *
          dl *
          0.000001; // Increased from 1.894
    } else {
      k = 0;
    }

    dmcPrev = dmcPrev + 100 * k;
    return dmcPrev;
  }

  double _calcDC(double temp, double rain, int month, double lat) {
    double rd = 0.0, qo, qr, v, d, dr, lf;

    // Rainfall adjustment
    if (rain > 2.8) {
      rd = 0.83 * rain - 1.27; // Formula for effective rainfall
      qo = 800 * exp(-dcPrev / 400); // Initial moisture content
      qr = qo + 3.937 * rd; // Adjusted moisture content
      dr = 400 * log(800 / qr); // Adjusted DC value

      // Update DCPrev based on Dr
      dcPrev = dr > 0 ? dr : 0;
    }

    // Calculate day length factor
    lf = _dayLengthFactor(lat, month - 1);

    // Adjust for temperature
    if (temp > -2.8) {
      v = 0.36 * (temp + 2.8) + lf; // Formula for moisture change
    } else {
      v = lf;
    }

    // Ensure V is non-negative
    if (v < 0) {
      v = 0;
    }

    // Calculate final DC
    d = dcPrev + 0.5 * v;

    return d;
  }

  double _calcISI(double wind, double ffmc) {
    // Increased wind sensitivity for Kuwait's open terrain
    double fWind = exp(0.1039 * wind); // Increased from 0.08039

    double m = 147.2 * (101 - ffmc) / (59.5 + ffmc);

    // Increased fire spread potential for arid conditions
    double fF = 91.9 * exp(-0.1086 * m) * (1 + pow(m, 5.31) / 42300000);

    return 0.508 * fWind * fF; // Increased from 0.408
  }

  double _calcBUI(double dmc, double dc) {
    double u;

    if (dmc <= 0.4 * dc) {
      u = 0.8 * dmc * dc / (dmc + 0.4 * dc);
    } else {
      u = dmc -
          (1 - 0.8 * dc / (dmc + 0.4 * dc)) * (0.92 + pow(0.0114 * dmc, 1.7));
    }

    return u;
  }

  double _calcFWI(double isi, double bui) {
    double fD, b, s;

    // Adjusted thresholds for Kuwait's vegetation
    if (bui <= 40) {
      // Lowered from 60
      fD = 1.026 * pow(bui, 0.809) + 2; // Increased from 0.826
    } else {
      fD = 1000 / (15 + 104.64 * exp(-0.030 * bui)); // Adjusted constants
    }

    b = 0.20 * isi * fD; // Increased from 0.15

    if (b > 1) {
      s = exp(2.92 * pow(0.434 * log(b), 0.647)); // Increased from 2.82
    } else {
      s = b;
    }

    return s;
  }

  double calcFWI(double temp, double rh, double wind, double rain, double lat) {
    double FFMC = _calcFFMC(temp, rh, wind, rain);
    double DMC = _calcDMC(temp, rh, rain, lat);
    int month = _currentMonth();
    double DC = _calcDC(temp, rain, month, lat);
    double ISI = _calcISI(wind, FFMC);
    double BUI = _calcBUI(DMC, DC);
    double FWI = _calcFWI(ISI, BUI);

    return FWI;
  }

  int _currentMonth() {
    DateTime now = DateTime.now();
    int month = now.month;
    return month;
  }

  double _dayLength(double latitude, int month) {
    // Day Length arrays for different latitude ranges
    List<double> dayLength46N = [
      6.5,
      7.5,
      9.0,
      12.8,
      13.9,
      13.9,
      12.4,
      10.9,
      9.4,
      8.0,
      7.0,
      6.0
    ];
    List<double> dayLength20N = [
      7.9,
      8.4,
      8.9,
      9.5,
      9.9,
      10.2,
      10.1,
      9.7,
      9.1,
      8.6,
      8.1,
      7.8
    ];
    List<double> dayLength20S = [
      10.1,
      9.6,
      9.1,
      8.5,
      8.1,
      7.8,
      7.9,
      8.3,
      8.9,
      9.4,
      9.9,
      10.2
    ];
    List<double> dayLength40S = [
      11.5,
      10.5,
      9.2,
      7.9,
      6.8,
      6.2,
      6.5,
      7.4,
      8.7,
      10.0,
      11.2,
      11.8
    ];

    double dayLengthValue = -1; // Default value for error

    // Determine the day length based on latitude
    if (latitude <= 90 && latitude > 33) {
      dayLengthValue = dayLength46N[month - 1];
    } else if (latitude <= 33 && latitude > 15) {
      dayLengthValue = dayLength20N[month - 1];
    } else if (latitude <= 15 && latitude > -15) {
      dayLengthValue = 9.0;
    } else if (latitude <= -15 && latitude > -30) {
      dayLengthValue = dayLength20S[month - 1];
    } else if (latitude <= -30 && latitude >= -90) {
      dayLengthValue = dayLength40S[month - 1];
    }

    return dayLengthValue;
  }

  double _dayLengthFactor(double latitude, int month) {
    // Day Length Factor arrays for Northern and Southern Hemispheres
    if (month == 0) {
      month = 1;
    }

    List<double> lfN = [
      -1.6,
      -1.6,
      -1.6,
      0.9,
      3.8,
      5.8,
      6.4,
      5.0,
      2.4,
      0.4,
      -1.6,
      -1.6
    ];
    List<double> lfS = [
      6.4,
      5.0,
      2.4,
      0.4,
      -1.6,
      -1.6,
      -1.6,
      -1.6,
      -1.6,
      0.9,
      3.8,
      5.8
    ];

    double dayLengthFactorValue = -1; // Default value for error

    if (latitude > 15) {
      // Use Northern Hemisphere numbers
      dayLengthFactorValue = lfN[month - 1];
    } else if (latitude <= 15 && latitude > -15) {
      // Use Equatorial numbers
      dayLengthFactorValue = 1.39;
    } else if (latitude <= -15) {
      // Use Southern Hemisphere numbers
      dayLengthFactorValue = lfS[month - 1];
    }

    return dayLengthFactorValue;
  }
}
