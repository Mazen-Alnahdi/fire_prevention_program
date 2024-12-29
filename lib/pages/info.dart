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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('نصائح للسلامة من الحرائق'),
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(255, 75, 0, 100),
          centerTitle: true,
          leading:
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))

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
                        child: const Column(
                          children: [
                            // Fire Safety in a Workplace Section
                            ExpansionTile(
                              title: Text(
                                "السلامة من الحرائق في مكان العمل",
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
                                    '1. قم بتركيب أجهزة كشف الدخان',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.smoke_free, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('تأكد من تركيب أجهزة كشف الدخان في كل طابق وفي المناطق عالية الخطورة مثل المطابخ.')),
                                    ListTile(title: Text('اختبر كاشفات الدخان بانتظام للتأكد من أنها تعمل بشكل صحيح.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '2. صيانة الأنظمة الكهربائية',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.electric_car, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('افحص الأسلاك بحثًا عن البلى، وتجنب التحميل الزائد على الدوائر.')),
                                    ListTile(title: Text('تأكد من أن الموظفين المؤهلين فقط هم من يقومون بأعمال الصيانة الكهربائية.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '3. التخزين الآمن للمواد القابلة للاشتعال',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.local_fire_department, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('تخزين السوائل القابلة للاشتعال في مناطق جيدة التهوية وبعيداً عن مصادر الحرارة.')),
                                    ListTile(title: Text('أبعد المواد القابلة للاشتعال عن الأجهزة الكهربائية وألسنة اللهب المكشوفة.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '4. طفايات الحريق ومعدات الطوارئ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.fire_extinguisher, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('ضع طفايات الحريق في الأماكن التي يسهل الوصول إليها.')),
                                    ListTile(title: Text('التأكد من تدريب الموظفين على كيفية استخدام طفايات الحريق.')),
                                    ListTile(title: Text('احتفظ بمجموعة طوارئ جيدة التجهيز تتضمن أدوات السلامة من الحرائق.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '5. تدريبات مكافحة الحرائق المنتظمة',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.access_alarm, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('قم بإجراء تدريبات منتظمة على الحرائق للتأكد من أن الموظفين يعرفون كيفية الإخلاء بأمان.')),
                                    ListTile(title: Text('تأكد من أن جميع طرق الهروب محددة بوضوح وخالية من العوائق.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '6. التعامل السليم مع معدات الطبخ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(Icons.kitchen, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('لا تترك معدات الطبخ دون مراقبة أثناء الاستخدام.')),
                                    ListTile(title: Text('قم بإيقاف تشغيل جميع أجهزة الطهي عند عدم استخدامها.')),
                                  ],
                                ),
                              ],
                            ),

                            // Fire Safety at Home Section
                            ExpansionTile(
                              title: Text(
                                "السلامة من الحرائق في المنزل",
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
                                    '1. قم بتركيب أجهزة كشف الدخان وأول أكسيد الكربون',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.smoke_free, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('قم بتركيب أجهزة الكشف في كل مستوى من منزلك وداخل مناطق النوم.')),
                                    ListTile(title: Text('اختبار أجهزة الكشف شهريا وتغيير البطاريات بانتظام.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '2. الحفاظ على السلامة الكهربائية',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.electric_car, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('فحص الأجهزة والأسلاك الكهربائية بحثاً عن أي ضرر.')),
                                    ListTile(title: Text('تجنب التحميل الزائد على المنافذ الكهربائية.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '3. أبعد المواد القابلة للاشتعال عن مصادر الحرارة',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.local_fire_department, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('قم بتخزين أعواد الثقاب والولاعات وغيرها من المواد القابلة للاشتعال في مكان آمن.')),
                                    ListTile(title: Text('احتفظ بالورق والملابس والمواد الأخرى القابلة للاشتعال بعيدًا عن المدافئ.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '4. إنشاء وممارسة خطة الهروب من الحريق',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.access_alarm, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('تأكد من أن جميع أفراد الأسرة يعرفون كيفية الهروب بأمان من كل غرفة.')),
                                    ListTile(title: Text('تدرب على طرق الهروب بانتظام، وحدد مكانًا للاجتماع بالخارج.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '5. استخدم مواد مقاومة للحريق للمفروشات',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.chair, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('فكر في الأثاث أو المفروشات المقاومة للحريق لمنزلك.')),
                                    ListTile(title: Text('استخدم أغطية النوافذ المقاومة للحريق، خاصة في المطابخ أو بالقرب من أجهزة التدفئة.')),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    '6. احتفظ بمطفأة حريق في المطبخ',
                                    style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  leading: Icon(Icons.fire_extinguisher, color: Colors.orange),
                                  children: [
                                    ListTile(title: Text('ضع طفاية الحريق في مكان يسهل الوصول إليه، خاصة بالقرب من المطبخ.')),
                                    ListTile(title: Text('معرفة كيفية استخدام طفاية الحريق بشكل صحيح في حالة الطوارئ.')),
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
