import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'معلومات الحماية من الحرائق',
            style: TextStyle(color: Colors.deepOrange),
          ),
          bottom: const TabBar(
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepOrange,
            tabs: [
              Tab(text: 'معلومات مؤشر الطقس الناري'),
              Tab(text: 'معلومات الطلاء'),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              title: '1. مؤشر طقس الحرائق المنخفض',
              content: [
                _buildContentBlock('التعريف',
                    'ظروف يكون فيها خطر اندلاع وانتشار الحرائق ضئيل للغاية.'),
                _buildContentBlock('خصائص الطقس', [
                  'درجات حرارة منخفضة: طقس معتدل أو بارد يقلل من خطر جفاف النباتات.',
                  'رطوبة عالية: مستويات رطوبة عالية في الهواء والنباتات تقلل القابلية للاشتعال.',
                  'رياح خفيفة أو معدومة: الرياح القليلة تقلل من خطر انتشار الحرائق.',
                  'هطول أمطار حديث: المطر الأخير أو المستمر يحافظ على الوقود (الأعشاب، الأوراق، والخشب) رطباً.',
                ]),
                _buildContentBlock('سلوك الحرائق', [
                  'من غير المرجح أن تبدأ الحرائق بشكل طبيعي، وإذا اشتعلت، تكون سهلة السيطرة أو الإطفاء.',
                  'انتشار الحرائق ضئيل، والنيران تكون صغيرة ومحدودة.',
                ]),
                _buildContentBlock('مثال',
                    'بداية الربيع أو موسم ما بعد الأمطار في المناطق المعتدلة.'),
              ],
            ),
            const Divider(),
            _buildCard(
              title: '2. مؤشر طقس الحرائق المتوسط',
              content: [
                _buildContentBlock('التعريف',
                    'ظروف يكون فيها خطر الحرائق معتدلًا مع زيادة احتمالية الاشتعال والانتشار.'),
                _buildContentBlock('خصائص الطقس', [
                  'درجات حرارة دافئة: دفء معتدل يجفف الوقود جزئيًا، مما يزيد من القابلية للاشتعال.',
                  'رطوبة متوسطة: انخفاض في الرطوبة، لكنها ليست جافة تمامًا.',
                  'رياح أقوى: الرياح تكون قوية بما يكفي للمساعدة في انتشار النيران إذا اشتعلت.',
                  'فترة جفاف: الطقس الجاف الأخير قد جفف النباتات جزئيًا، مما يجعلها أكثر عرضة للاشتعال.',
                ]),
                _buildContentBlock('سلوك الحرائق', [
                  'يمكن أن تشتعل الحرائق بسهولة أكبر وتنتشر بشكل معتدل.',
                  'إخماد الحرائق ممكن، ولكنه يتطلب جهدًا أكبر مقارنةً بظروف مؤشر الطقس الناري المنخفضة.',
                ]),
                _buildContentBlock('مثال',
                    'أيام الصيف الجافة مع نسيم عرضي في الغابات أو الأراضي العشبية.'),
              ],
            ),
            const Divider(),
            _buildCard(
              title: '3. مؤشر طقس الحرائق المرتفع',
              content: [
                _buildContentBlock('التعريف',
                    'ظروف يكون فيها خطر الحرائق مرتفعًا للغاية، حيث من المحتمل أن تشتعل النيران وتنتشر بسرعة.'),
                _buildContentBlock('خصائص الطقس', [
                  'درجات حرارة عالية: الحرارة العالية تجفف النباتات، مما يجعلها وقودًا قابلاً للاشتعال بشدة.',
                  'رطوبة منخفضة: قلة الرطوبة في الهواء والنباتات تزيد من مخاطر الاشتعال.',
                  'رياح قوية: الرياح القوية تنشر النيران بسرعة عبر الوقود، مما يزيد من شدة الحرائق.',
                  'جفاف طويل: فترات طويلة من قلة أو عدم هطول الأمطار تجعل الوقود جافًا وقابلًا للاشتعال بشدة.',
                ]),
                _buildContentBlock('سلوك الحرائق', [
                  'تشتعل الحرائق بسهولة شديدة ويمكن أن تصبح غير قابلة للسيطرة بسرعة.',
                  'النيران تنتشر بسرعة ويمكنها تجاوز العوائق مثل خطوط النار أو الطرق أو الأنهار.',
                  'إخماد الحرائق يكون صعبًا للغاية ويتطلب موارد واسعة النطاق.',
                ]),
                _buildContentBlock('مثال',
                    'موجات الحر أو ظروف الجفاف، خاصة في المناطق المعرضة للحرائق مثل كاليفورنيا أو أستراليا أو البحر الأبيض المتوسط خلال فصل الصيف.'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCoatingInfo() {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: '1. الطلاءات المنتفخة',
            content: [
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'خطر الاشتعال ضئيل؛ يبقى الطلاء غير نشط. موصى به للاستخدام الوقائي على الأشجار أو البنى التحتية ذات القيمة العالية.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'يوفر مقاومة ممتازة للنيران للعوامل الصغيرة مثل الشرر أو اللهب الطفيف.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'يشكل طبقة كربونية لحماية السطح من الحرارة العالية والنيران.',
              ),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '2. مثبطات الحريق القائمة على البورون',
            content: [
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'فعالة في تقليل مخاطر الاشتعال البسيطة الناتجة عن الشرر الصغير.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'يتطلب تطبيقًا أكثر تكرارًا خلال الظروف الجافة.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'التطبيق المتكرر ضروري. أقل فعالية ضد النيران شديدة الكثافة.',
              ),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '3. مثبطات الحريق الهلامية',
            content: [
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'فائدة محدودة في الظروف ذات المخاطر المنخفضة، حيث أن المواد الهلامية حلول قصيرة الأمد. '
                    'الأفضل الاحتفاظ بها للاستخدام الوقائي عند توقع زيادة خطر الحريق (مثلًا قبل موجة حر أو في مناطق معرضة للحرائق).',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'فعالة للغاية في حماية الأشجار أو المناطق المعرضة للخطر المباشر. '
                    'تلتصق المواد الهلامية بشكل جيد وتشكل حاجزًا للرطوبة، مما يقلل من مخاطر الاشتعال في الظروف المعتدلة. '
                    'يجب مراقبتها لضمان بقائها سليمة، خاصةً في الطقس الجاف.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'فعالة للغاية في حماية الأشجار بشكل مؤقت خلال حالات الطوارئ المتعلقة بالحرائق. '
                    'يتطلب تطبيقًا سريعًا قبل وقوع الحريق بسبب قصر مدة فعاليتها. '
                    'يمكن أن تؤخر انتشار النيران، مما يوفر الوقت لجهود إخماد الحريق.',
              ),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '4. المواد الطينية كمثبطات حرائق',
            content: [
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'فائدة منخفضة في هذه الظروف حيث تكون مخاطر الحرائق قليلة. '
                    'قد تجف المواد الطينية وتتشقق مع مرور الوقت، مما يقلل من فعاليتها. '
                    'يمكن استخدامها بشكل وقائي على أشجار معينة لإضافة الأمان.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'توفر مقاومة متوسطة للنيران من خلال تشكيل حاجز عازل. '
                    'تتطلب صيانة حيث تجف المادة الطينية وت deteriorate تحت الضغط البيئي (مثل الرياح أو الحرارة).',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'أقل فعالية في ظل ظروف الحرائق الشديدة. '
                    'قد تتشقق المادة الطينية أو تتساقط تحت الحرارة العالية أو في حالة الرياح القوية المصاحبة للحرائق. '
                    'قد توفر حماية محدودة على المدى القصير للأشجار ذات القيمة العالية.',
              ),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '5. مثبطات الحرائق التجارية المتخصصة',
            content: [
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'غير ضرورية في الظروف ذات المخاطر المنخفضة؛ من الأفضل التركيز على التخطيط والاستعداد عند زيادة خطر الحرائق. '
                    'قد تُستخدم بشكل استراتيجي لإنشاء خطوط النار أو حماية الأشجار الهامة.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'فعالة للغاية في تقليل الاشتعال وانتشار النيران. '
                    'الأفضل استخدامها في المناطق المعرضة للحرائق أو حيث قد تتأخر موارد إخماد الحرائق.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'من بين الحلول الأكثر فعالية في الظروف ذات المخاطر العالية. '
                    'تشكل حاجزًا كيميائيًا متينًا يمكنه مقاومة الحرارة العالية والنيران. '
                    'يتطلب إعادة تطبيق متكرر في حالة هطول الأمطار أو أحداث الحرائق الطويلة.',
              ),
            ],
          ),
        ],
      ),
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
          ...content.map((item) =>
              Text('- $item', style: const TextStyle(color: Colors.deepOrange))),
      ],
    ),
  );
}
