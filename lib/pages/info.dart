import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(text: 'معاني نتائج مؤشر الحريق'),
              Tab(text: 'الوقاية من الحريق'),
              Tab(text: 'السلامة المنزلية'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFWIInfo(),
            _buildCoatingInfo(),
            _buildHomeSafetyInfo()
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
            title: '1. الطلاءات المنفخة (لاشجار الغابات)',
            content: [
              _buildContentBlock(
                'الوصف',
                'طلاء فعال يستخدم تقنية الانتفاخ عند تعرضه للنيران لتكوين طبقة عازلة من الكربون تحمي السطح من الحرارة العالية.',
              ),
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
                'الوصف',
                'مواد كيميائية تعتمد على البورون تعمل على تقليل قابلية الاشتعال وتثبط انتشار النيران بشكل فعال.',
              ),
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
                'الوصف',
                'مواد هلامية تشكل حاجزًا رطبًا مؤقتًا لحماية السطح من الاشتعال في الظروف عالية الخطورة.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'فائدة محدودة في الظروف ذات المخاطر المنخفضة، حيث أن المواد الهلامية حلول قصيرة الأمد.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'فعالة للغاية في حماية الأشجار أو المناطق المعرضة للخطر المباشر.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'فعالة للغاية في حماية الأشجار بشكل مؤقت خلال حالات الطوارئ المتعلقة بالحرائق.',
              ),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '4. المواد الطينية كمثبطات حرائق',
            content: [
              _buildContentBlock(
                'الوصف',
                'مواد طبيعية تعمل كحاجز حراري مؤقت لحماية الأسطح من النيران والحرارة.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'فائدة منخفضة في هذه الظروف حيث تكون مخاطر الحرائق قليلة.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'توفر مقاومة متوسطة للنيران من خلال تشكيل حاجز عازل.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'أقل فعالية في ظل ظروف الحرائق الشديدة.',
              ),
            ],
          ),
          const Divider(),
          _buildCard(
            title: '5. مثبطات الحرائق التجارية المتخصصة',
            content: [
              _buildContentBlock(
                'الوصف',
                'منتجات كيميائية متقدمة مصممة لتوفير حماية طويلة الأمد ضد النيران والحرارة الشديدة.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري منخفض',
                'غير ضرورية في الظروف ذات المخاطر المنخفضة؛ من الأفضل التركيز على التخطيط والاستعداد.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري متوسط',
                'فعالة للغاية في تقليل الاشتعال وانتشار النيران.',
              ),
              _buildContentBlock(
                'مؤشر الطقس الناري مرتفع',
                'من بين الحلول الأكثر فعالية في الظروف ذات المخاطر العالية.',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildHomeSafetyInfo() {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildIllustratedCard(
            title: '1. تركيب أجهزة كشف الدخان وأول أكسيد الكربون',
            illustration: 'assets/images/smoke_detector.png',
            content: [
              _buildContentBlock(
                'الوصف',
                'قم بتركيب أجهزة الكشف في جميع طوابق المنزل وداخل غرف النوم.',
              ),
              _buildContentBlock(
                'النصائح',
                [
                  'تفحص الأجهزة شهريًا للتأكد من أنها تعمل بشكل صحيح.',
                  'قم باستبدال البطاريات بانتظام أو عند سماع إشارات تحذيرية.',
                ],
              ),
            ],
          ),
          const Divider(),
          _buildIllustratedCard(
            title: '2. الحفاظ على السلامة الكهربائية',
            illustration: 'assets/images/electrical_safety.png',
            content: [
              _buildContentBlock(
                'الوصف',
                'السلامة الكهربائية تقلل من خطر الحرائق الناتجة عن التوصيلات الكهربائية التالفة أو الاستخدام الزائد.',
              ),
              _buildContentBlock(
                'النصائح',
                [
                  'تفقد الأجهزة الكهربائية والأسلاك بانتظام للتأكد من عدم وجود تلف أو سخونة زائدة.',
                  'تجنب تحميل المنافذ الكهربائية فوق طاقتها باستخدام مقاسم كهرباء غير معتمدة.',
                ],
              ),
            ],
          ),
          const Divider(),
          _buildIllustratedCard(
            title: '3. إبعاد المواد القابلة للاشتعال عن مصادر الحرارة',
            illustration: 'assets/images/fire_safety.png',
            content: [
              _buildContentBlock(
                'الوصف',
                'يمكن للمواد القابلة للاشتعال أن تشتعل بسهولة إذا وُضعت بالقرب من مصادر الحرارة.',
              ),
              _buildContentBlock(
                'النصائح',
                [
                  'قم بتخزين الكبريت والولاعات في أماكن آمنة وبعيدة عن متناول الأطفال.',
                  'احتفظ بالورق والملابس بعيدًا عن المدافئ أو أجهزة التدفئة.',
                ],
              ),
            ],
          ),
          const Divider(),
          _buildIllustratedCard(
            title: '4. إنشاء خطة هروب من الحريق وممارستها',
            illustration: 'assets/images/escape_plan.png',
            content: [
              _buildContentBlock(
                'الوصف',
                'وجود خطة هروب يساعد على تقليل الخسائر أثناء الحرائق المنزلية.',
              ),
              _buildContentBlock(
                'النصائح',
                [
                  'تأكد من أن جميع أفراد العائلة يعرفون كيفية الهروب بأمان من كل غرفة.',
                  'قم بممارسة خطط الهروب بانتظام وحدد نقطة تجمع خارج المنزل.',
                ],
              ),
            ],
          ),
          const Divider(),
          _buildIllustratedCard(
            title: '5. استخدام مواد مقاومة للحرائق في الأثاث',
            illustration: 'assets/images/fireproof_furniture.png',
            content: [
              _buildContentBlock(
                'الوصف',
                'اختيار مواد مقاومة للحرائق يقلل من انتشار النيران في حال حدوث حريق.',
              ),
              _buildContentBlock(
                'النصائح',
                [
                  'فكر في استخدام أثاث أو أقمشة مقاومة للحرائق في منزلك.',
                  'استخدم ستائر مقاومة للحرائق، خاصةً في المطابخ أو بالقرب من أجهزة التدفئة.',
                ],
              ),
            ],
          ),
          const Divider(),
          _buildIllustratedCard(
            title: '6. الاحتفاظ بمطفأة حريق في المطبخ',
            illustration: 'assets/images/fire_extinguisher.png',
            content: [
              _buildContentBlock(
                'الوصف',
                'وجود مطفأة حريق في المطبخ يمكن أن يكون مفيدًا لإخماد الحرائق الصغيرة بسرعة.',
              ),
              _buildContentBlock(
                'النصائح',
                [
                  'ضع مطفأة حريق في مكان يسهل الوصول إليه، خاصةً بالقرب من المطبخ.',
                  'تعلم كيفية استخدام مطفأة الحريق بشكل صحيح في حالة الطوارئ.',
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget _buildIllustratedCard({
  required String title,
  required String illustration,
  required List<Widget> content,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                illustration,
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ...content,
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
