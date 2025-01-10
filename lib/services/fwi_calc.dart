import 'dart:math';

class FireWeatherIndex {
  double _calcFFMC(double temp, double rh, double wind, double rain) {
    double mo, rf, mr, ed, ew, ko, kd, kl, kw, m, F;
    double ffmcPrev = 0;

    // Calculate initial mo value
    mo = 147.2 * (101 - ffmcPrev) / (59.5 + ffmcPrev);

    // If rain is greater than 0.5, calculate Mr
    if (rain > 0.5) {
      rf = rain - 0.5;
      if (mo <= 150) {
        mr = mo + 42.5 * rf * (exp(-100 / (251 - mo))) * (1 - exp(-6.93 / rf));
      } else {
        mr = mo + 42.5 * rf * (exp(-100 / (251 - mo))) * (1 - exp(-6.93 / rf)) +
            0.0015 * (mo - 150) * (mo - 150) * pow(rf, 0.5);
      }
      if (mr > 250) {
        mr = 250;
      }
      mo = mr;
    }

    // Calculate Ed
    ed = 0.942 * pow(rh, 0.679) +
        11 * exp((rh - 100) / 10) +
        0.18 * (21.1 - temp) * (1 - exp(-0.115 * rh));

    // If mo is greater than Ed, calculate ko and m
    if (mo > ed) {
      ko = 0.424 * (1 - pow(rh / 100, 1.7)) +
          0.0694 * pow(wind, 0.5) * (1 - pow(rh / 100, 8));
      kd = ko * 0.581 * exp(0.0365 * temp);
      m = ed + (mo - ed) * pow(10, -kd);
    } else {
      // Else calculate Ew and m
      ew = 0.618 * pow(rh, 0.753) +
          10 * exp((rh - 100) / 10) +
          0.18 * (21.1 - temp) * (1 - exp(-0.115 * rh));

      if (mo < ew) {
        kl = 0.424 * (1 - pow((100 - rh) / 100, 1.7)) +
            0.0694 * pow(wind, 0.5) * (1 - pow((100 - rh) / 100, 8));
        kw = kl * 0.581 * exp(0.0365 * temp);
        m = ew - (ew - mo) * pow(10, -kw);
      } else {
        m = mo;
      }
    }

    // Calculate FFMC
    return 59.5 * (250 - m) / (147.2 + m);
  }

  double _calcDMC(double temp, double rh, double rain, double lat) {
    double re = 0;
    double mo, mr, k, b = 0, pr, dl;
    double dmcPrev=0;


    int month = _currentMonth();



    // Check if rainfall affects DMC
    if (rain > 1.5) {
      re = 0.92 * rain - 1.27; // Formula for effective rainfall
      mo = 20 + exp(5.6348 - dmcPrev / 43.43); // Adjust mo value

      // Determine the value of B based on DMCPrev
      if (dmcPrev <= 33) {
        b = 100 / (0.5 + 0.3 * dmcPrev);
      } else if (dmcPrev <= 65) {
        b = 14 - 1.3 * log(dmcPrev);
      } else {
        b = 6.2 * log(dmcPrev) - 17.2;
      }

      // Calculate Mr and Pr
      mr = mo + 1000 * re / (48.77 + b * re);
      pr = 244.72 - 43.43 * log(mr - 20);

      // Update DMCPrev
      if (pr > 0) {
        dmcPrev = pr;
      } else {
        dmcPrev = 0;
      }
    }

    // Temperature adjustment and day length factor
    if (temp > -1.1) {
      dl = _dayLength(lat, month);
      k = 1.894 * (temp + 1.1) * (100 - rh) * dl * 0.000001;
    } else {
      k = 0;
    }

    // Final DMC calculation
    return dmcPrev + 100 * k;
  }

  double _calcDC(double temp, double rain, int month, double lat) {
    double rd = 0.0, qo, qr, v, d, dr, lf;
    double dcPrev = 200;

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

  double _calcISI(double wind, double ffmc){
    // Calculate fWIND
    double fWind = exp(0.05039 * wind);

    // Calculate m
    double m = 147.2 * (101 - ffmc) / (59.5 + ffmc);

    // Calculate fF
    double fF = 91.9 * exp(-0.1386 * m) * (1 + pow(m, 5.31) / 49300000);

    // Calculate ISI
    double isiValue = 0.208 * fWind * fF;

    return isiValue;
  }

  double _calcBUI(double dmc, double dc){
    double u;

    if (dmc <= 0.4 * dc) {
      u = 0.8 * dmc * dc / (dmc + 0.4 * dc);
    } else {
      u = dmc -
          (1 - 0.8 * dc / (dmc + 0.4 * dc)) *
              (0.92 + pow(0.0114 * dmc, 1.7));
    }

    return u;
  }

  double _calcFWI(double isi, double bui){
    double fD, b, s;

    // Calculate fD based on BUI
    if (bui <= 80) {
      fD = 0.626 * pow(bui, 0.809) + 2; // Equation 28a
    } else {
      fD = 1000 / (25 + 108.64 * exp(-0.023 * bui)); // Equation 28b
    }

    // Calculate B
    b = 0.1 * isi * fD; // Equation 29

    // Calculate S
    if (b > 1) {
      s = exp(2.72 * pow(0.434 * log(b), 0.647)); // Equation 30a
    } else {
      s = b; // Equation 30b
    }

    return s; // FWI value
  }

  double calcFWI(double temp, double rh, double wind, double rain, double lat){
    double FFMC=_calcFFMC(temp, rh, wind, rain);
    double DMC=_calcDMC(temp, rh, rain, lat);
    int month=_currentMonth();
    double DC=_calcDC(temp, rain, month, lat);
    double ISI = _calcISI(wind, FFMC);
    double BUI=_calcBUI(DMC, DC);
    double FWI = _calcFWI(ISI, BUI);

    return FWI;
  }

  int _currentMonth(){
    DateTime now=DateTime.now();
    int month = now.month;
    return month;
  }

  double _dayLength(double latitude, int month) {
    // Day Length arrays for different latitude ranges
    List<double> dayLength46N = [6.5, 7.5, 9.0, 12.8, 13.9, 13.9, 12.4, 10.9, 9.4, 8.0, 7.0, 6.0];
    List<double> dayLength20N = [7.9, 8.4, 8.9, 9.5, 9.9, 10.2, 10.1, 9.7, 9.1, 8.6, 8.1, 7.8];
    List<double> dayLength20S = [10.1, 9.6, 9.1, 8.5, 8.1, 7.8, 7.9, 8.3, 8.9, 9.4, 9.9, 10.2];
    List<double> dayLength40S = [11.5, 10.5, 9.2, 7.9, 6.8, 6.2, 6.5, 7.4, 8.7, 10.0, 11.2, 11.8];

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
    if(month==0){
      month=1;
    }

    List<double> lfN = [-1.6, -1.6, -1.6, 0.9, 3.8, 5.8, 6.4, 5.0, 2.4, 0.4, -1.6, -1.6];
    List<double> lfS = [6.4, 5.0, 2.4, 0.4, -1.6, -1.6, -1.6, -1.6, -1.6, 0.9, 3.8, 5.8];

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