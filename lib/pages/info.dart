import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Fire Protection Info',
            style: TextStyle(color: Colors.deepOrange),
          ),
          bottom: const TabBar(
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepOrange,
            tabs: [
              Tab(text: 'FWI Info'),
              Tab(text: 'Coating Info'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFWIInfo(),
            _buildCoatingInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildFWIInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: '1. Low Fire Weather Index',
            content: [
              _buildContentBlock('Definition',
                  'Conditions where the risk of a wildfire starting and spreading is minimal.'),
              _buildContentBlock('Weather Characteristics', [
                'Cool temperatures: Typically mild or cool weather with little risk of vegetation drying out.',
                'High humidity: Moisture levels in the air and vegetation are high, reducing flammability.',
                'Light or no wind: Minimal wind means low risk of fire spread.',
                'Recent precipitation: Recent or ongoing rain ensures that fuels (grass, leaves, and wood) remain damp.',
              ]),
              _buildContentBlock('Fire Behavior', [
                'Fires are unlikely to start naturally and, if ignited, are easy to control or extinguish.',
                'Fire spread is minimal, and flames tend to be small and localized.',
              ]),
              _buildContentBlock('Example', 'Early spring or post-rainy season in temperate regions.'),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '2. Medium Fire Weather Index',
            content: [
              _buildContentBlock('Definition',
                  'Conditions where fire risks are moderate, with increased potential for ignition and spread.'),
              _buildContentBlock('Weather Characteristics', [
                'Warmer temperatures: Moderate warmth dries out fuels partially, increasing flammability.',
                'Moderate humidity: Reduced moisture in the air, but not yet critically dry.',
                'Stronger winds: Winds are strong enough to assist in the spread of fire if it starts.',
                'Drying period: Recent dry weather may have partially dried vegetation, making it more susceptible to ignition.',
              ]),
              _buildContentBlock('Fire Behavior', [
                'Fires can ignite more easily and spread moderately if they occur.',
                'Fire suppression is manageable but may require more effort than under low FWI conditions.',
              ]),
              _buildContentBlock('Example',
                  'Dry summer days with occasional breezes in forests or grasslands.'),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '3. High Fire Weather Index',
            content: [
              _buildContentBlock('Definition',
                  'Conditions where wildfire risk is very high, with fires likely to ignite and spread rapidly.'),
              _buildContentBlock('Weather Characteristics', [
                'Hot temperatures: High heat dries out vegetation, creating highly flammable fuel.',
                'Low humidity: Minimal moisture in the air and vegetation increases ignition risks.',
                'Strong winds: High winds spread flames rapidly across fuels, increasing fire intensity.',
                'Prolonged dryness: Extended periods of little to no rain lead to extremely dry and combustible fuels.',
              ]),
              _buildContentBlock('Fire Behavior', [
                'Fires start very easily and can become uncontrollable quickly.',
                'Flames spread rapidly and can jump firebreaks, roads, or rivers.',
                'Fire suppression is extremely challenging and requires extensive resources.',
              ]),
              _buildContentBlock('Example',
                  'Heatwaves or drought conditions, especially in wildfire-prone regions like California, Australia, or the Mediterranean during peak summer.'),
            ],
          ),
        ],
      ),
    );
  }

}

Widget _buildCoatingInfo() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        _buildCard(
          title: '1. Intumescent Coatings',
          content: [
            _buildContentBlock('Low FWI',
                'Minimal risk of ignition; coating remains inactive. Recommended for proactive use on high-value trees or infrastructure.'),
            _buildContentBlock('Medium FWI',
                'Provides excellent fire resistance to isolated sparks, embers, or minor flame exposure.'),
            _buildContentBlock('High FWI',
                'Forms a char layer to protect from high heat and flames.'),
          ],
        ),
        const Divider(),
        _buildCard(
          title: '2. Boron-Based Fire Retardants',
          content: [
            _buildContentBlock('Low FWI',
                'Effective at reducing minor ignition risks from small sparks.'),
            _buildContentBlock('Medium FWI',
                'Requires more frequent application during dry conditions.'),
            _buildContentBlock('High FWI',
                'Frequent reapplication is essential. Less effective against high-intensity flames.'),
          ],
        ),
        Divider(),
        _buildCard(
          title: '3. Gel Fire Retardants',
          content: [
            _buildContentBlock(
                'Low FWI',
                'Limited utility in low-risk conditions since gels are short-term solutions. '
                    'Best saved for preemptive use when fire risks are expected to rise (e.g., before a heatwave or in wildfire-prone areas).'),
            _buildContentBlock(
                'Medium FWI',
                'Highly effective for protecting specific trees or areas at immediate risk. '
                    'Gels adhere well and maintain a moisture barrier, reducing ignition risks in moderate conditions. '
                    'Must be monitored to ensure they remain intact, especially in dry weather.'),
            _buildContentBlock(
                'High FWI',
                'Extremely effective in shielding trees temporarily during wildfire emergencies. '
                    'Requires rapid application just before a fire event due to its short-lived nature. '
                    'Can delay flame spread, buying time for fire suppression efforts.'),
          ],
        ),
        Divider(),
        _buildCard(
          title: '4. Clay-Based Slurries',
          content: [
            _buildContentBlock(
                'Low FWI',
                'Low utility in these conditions since fire risks are minimal. Clay slurries may dry and crack over time, reducing effectiveness. '
                    'Can be used proactively on specific trees for added safety.'),
            _buildContentBlock(
                'Medium FWI',
                'Provides moderate fire resistance by forming an insulating barrier. '
                    'Requires maintenance as the slurry dries and deteriorates under environmental stress (e.g., wind or heat).'),
            _buildContentBlock(
                'High FWI',
                'Less effective under intense fire conditions. '
                    'Clay can crack or fall off under high heat or if strong winds accompany the fire. '
                    'May provide limited short-term protection for specific, high-value trees.'),
          ],
        ),
        Divider(),
        _buildCard(
          title: '5. Specialized Commercial Fire Retardants',
          content: [
            _buildContentBlock(
                'Low FWI',
                'Overkill for low-risk conditions; focus is better placed on planning and readiness for when fire risks increase. '
                    'May be applied strategically to create firebreaks or protect critical trees.'),
            _buildContentBlock(
                'Medium FWI',
                'Highly effective at reducing ignition and flame spread. '
                    'Best used in areas at risk of wildfires or where fire suppression resources might be delayed.'),
            _buildContentBlock(
                'High FWI',
                'Among the most effective solutions for high-risk conditions. '
                    'Forms a durable, chemical barrier that can withstand intense heat and flames. '
                    'Requires frequent reapplication in case of rain or prolonged fire events.'),
          ],
        ),
      ],
    ),
  );
}



Widget _buildCard({required String title, required List<Widget> content}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 16.0),
          ...content,
        ],
      ),
    ),
  );
}

Widget _buildContentBlock(String title, dynamic content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        if (content is String)
          Text(
            content,
            style: const TextStyle(color: Colors.deepOrange),
          )
        else if (content is List<String>)
          ...content.map((item) => Text('- $item', style: const TextStyle(color: Colors.deepOrange))),
      ],
    ),
  );
}
