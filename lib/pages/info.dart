import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fire Safety Tips'),
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
          centerTitle: true,
        ),
        body:
        Padding(padding: EdgeInsets.only(bottom: 65),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: Column(
                          children: [
                            // Fire Safety in a Workplace Section
                            ExpansionTile(
                              title: Text(
                                "Fire Safety in a Workplace",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Icon(Icons.fireplace, color: Colors.orange),
                              initiallyExpanded: true,
                              children: [
                                ExpansionTile(
                                  title: Text(
                                    '1. Install Smoke Detectors',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.smoke_free, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Ensure smoke detectors are installed on every floor and in high-risk areas like kitchens.')),
                                    ListTile(title: Text('Test smoke detectors regularly to ensure they are working properly.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '2. Maintain Electrical Systems',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.electric_car, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Check wiring for wear and tear, and avoid overloading circuits.')),
                                    ListTile(title: Text('Ensure that only qualified personnel perform electrical maintenance.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '3. Safe Storage of Flammable Materials',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.local_fire_department, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Store flammable liquids in well-ventilated areas and away from heat sources.')),
                                    ListTile(title: Text('Keep flammable materials away from electrical equipment and open flames.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '4. Fire Extinguishers and Emergency Kits',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.fire_extinguisher, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Place fire extinguishers in easily accessible areas.')),
                                    ListTile(title: Text('Ensure employees are trained in how to use fire extinguishers.')),
                                    ListTile(title: Text('Maintain a well-stocked emergency kit that includes fire safety tools.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '5. Regular Fire Drills',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.access_alarm, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Conduct regular fire drills to ensure employees know how to evacuate safely.')),
                                    ListTile(title: Text('Ensure all escape routes are clearly marked and unobstructed.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '6. Proper Handling of Cooking Equipment',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.kitchen, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Do not leave cooking equipment unattended while in use.')),
                                    ListTile(title: Text('Turn off all cooking appliances when not in use.')),
                                  ],
                                ),
                              ],
                            ),

                            // Fire Safety at Home Section
                            ExpansionTile(
                              title: Text(
                                "Fire Safety at Home",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Icon(Icons.home, color: Colors.orange),
                              initiallyExpanded: true,
                              children: [
                                ExpansionTile(
                                  title: Text(
                                    '1. Install Smoke and Carbon Monoxide Detectors',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.smoke_free, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Install detectors on every level of your home and inside sleeping areas.')),
                                    ListTile(title: Text('Test detectors monthly and change the batteries regularly.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '2. Maintain Electrical Safety',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.electric_car, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Inspect electrical appliances and cords for damage.')),
                                    ListTile(title: Text('Avoid overloading electrical outlets.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '3. Keep Flammable Items Away from Heat Sources',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.local_fire_department, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Store matches, lighters, and other flammable items in a safe place.')),
                                    ListTile(title: Text('Keep paper, clothing, and other flammable materials away from space heaters.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '4. Create and Practice a Fire Escape Plan',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.access_alarm, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Ensure all family members know how to escape safely from every room.')),
                                    ListTile(title: Text('Practice escape routes regularly, and identify a meeting spot outside.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '5. Use Fire-Resistant Materials for Furnishings',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.chair, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Consider fire-resistant furniture or upholstery for your home.')),
                                    ListTile(title: Text('Use fire-resistant window coverings, especially in kitchens or near heating devices.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '6. Keep a Fire Extinguisher in the Kitchen',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.fire_extinguisher, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('Place a fire extinguisher in a location that is easy to access, especially near the kitchen.')),
                                    ListTile(title: Text('Know how to use the fire extinguisher correctly in case of an emergency.')),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}
