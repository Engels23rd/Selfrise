import 'dart:io';
import 'package:flutter_proyecto_final/Design/podcast/podcastcontroller.dart';
import 'package:map_location_picker/generated/l10n.dart';

final podcascards = <cardsdata>[
  cardsdata(
      id: 1,
      categoria: "Motivación",
      autor: "Llados",
      name:
          "LOS CONSEJOS DE VIDA DE LLADOS te dejaran sin palabras | Motivación para cambiar tu vida",
      image: "assets/podcast/motivacion/Llados.png",
      link: "https://youtu.be/3bX_XFVQ2KE?si=yu-32t-2kY-NGGU5",
      description: "El podcast presenta consejos de vida motivacionales impartidos por Llados," +
          " destinados a inspirar y motivar a los espectadores para cambiar sus vidas. " +
          " Llados aborda temas relacionados con el desarrollo personal, el crecimiento emocional" +
          " y la superación de obstáculos. El objetivo es proporcionar mensajes directos y motivadores" +
          " para alcanzar el máximo potencial."),
  cardsdata(
      id: 2,
      categoria: "Motivación",
      autor: "TEMACH",
      name: "Los primeros 10 pasos del Alfa - TemachVlog CAP32",
      image: "assets/podcast/motivacion/Temach.png",
      link: "https://youtu.be/ZltTK8-OuEY?si=qaBXvmQfmBAYVPSv",
      description:
          "Temach comparte los primeros 10 pasos esenciales para convertirse en un alfa. Este podcast" +
              " ofrece consejos prácticos y motivacionales para superar desafíos, aumentar la autoconfianza y" +
              " alcanzar metas personales y profesionales. Se enfoca en inspirar a los espectadores a adoptar" +
              " una mentalidad positiva y proactiva para lograr el éxito."),
  cardsdata(
      id: 3,
      categoria: "Motivación",
      autor: "Daniel Habif",
      name: "¡YO NO ME SÉ RENDIR! - Daniel Habif",
      image: "assets/podcast/motivacion/Daniel-Habif.png",
      link: "https://youtu.be/DJAVgwlljvA?si=n6nmrdfyaj5MCvDf",
      description:
          "Daniel Habif presenta un mensaje apasionado sobre la importancia de no rendirse ante los desafíos de la" +
              " vida. Su enfoque único y emotivo aborda temas como el propósito de vida, la resiliencia y el amor propio," +
              " con el objetivo de inspirar a los espectadores a vivir de manera más auténtica y plena."),
  cardsdata(
      id: 4,
      categoria: "Motivación",
      autor: "Motiversity en Español",
      name:
          "GANAR LA MAÑANA, ¡GANAR EL DÍA! | Motivación Positiva Para la Mañana (recopilación)",
      image: "assets/podcast/motivacion/Motiversity.png",
      link: "https://youtu.be/eAcPYVveCsc?si=O5BpafyBEjmdD_qm",
      description:
          "Motiversity en Español ofrece una compilación de discursos motivacionales diseñados para ayudar a los" +
              " espectadores a comenzar el día con energía y determinación. El podcast enfatiza la importancia de establecer" +
              " una rutina matutina positiva para impulsar el éxito personal y alcanzar los objetivos."),
  cardsdata(
      id: 5,
      categoria: "Motivación",
      autor: "Yokoi Kenji",
      name: "MOTIVACIÓN? | YOKOI KENJI",
      image: "assets/podcast/motivacion/Yokoi-Kenji.png",
      link: "https://youtu.be/TQOeEy03yq0?si=9eCFgSp34e90fHlI",
      description:
          "Yokoi Kenji fusiona la filosofía oriental con enseñanzas motivacionales dirigidas al público latinoamericano." +
              " A través de sus historias, reflexiones y lecciones de vida, busca promover el crecimiento personal y el bienestar" +
              " emocional. Sus mensajes están impregnados de sabiduría y humildad, inspirando a los espectadores a encontrar" +
              " significado en sus vidas."),
  cardsdata(
      id: 1,
      categoria: "Salud Mental",
      autor: "Cordura Artificial",
      name: "Tu problema no es la procastinación",
      image: "assets/podcast/salud-mental/Cordura-Artificial.png",
      link: "https://youtu.be/sJO-lbKmLtc?si=QJwTFE42-dv7m1zA",
      description:
          "En este podcast, Cordura Artificial aborda el tema de la procrastinación y argumenta que el problema subyacente no es" +
              " la procrastinación en sí misma, sino otras cuestiones más profundas. El enfoque del podcast es ofrecer una perspectiva" +
              " única sobre este comportamiento y proporcionar estrategias para superarlo."),
  cardsdata(
      id: 2,
      categoria: "Salud Mental",
      autor: "Farid Dieck",
      name: "FARIDIECK #48. La aceptación",
      image: "assets/podcast/salud-mental/farid.png",
      link: "https://youtu.be/-MQK0jfe_vE?si=4KlHG6qI_O44P7l7",
      description:
          "En este episodio, Farid Dieck explora el concepto de aceptación y su importancia en el crecimiento personal" +
              " y la espiritualidad. A través de reflexiones profundas y perspicaces, el podcast invita a los espectadores a" +
              " practicar la aceptación como una herramienta para encontrar la paz interior y la felicidad."),
  cardsdata(
      id: 3,
      categoria: "Salud Mental",
      autor: "Esquizofrenia Natural",
      name: "La MODA de la PSEUDO PSICOLOGÍA – Podcast",
      image: "assets/podcast/salud-mental/Esquizofrenia-natural.png",
      link: "https://youtu.be/ioyFO_QRD-4?si=oieLEe6K82j0OrdG",
      description:
          "Esquizofrenia Natural aborda el fenómeno de la pseudo psicología en este podcast, destacando la importancia de" +
              " discernir entre información válida y pseudocientífica en el ámbito de la salud mental. El objetivo del podcast" +
              " es educar y desmitificar conceptos erróneos relacionados con la psicología."),
  cardsdata(
      id: 4,
      categoria: "Salud Mental",
      autor: "UN POCO MEJOR",
      name:
          "Cómo dejar de darle demasiada importancia a todo//El poder del ahora-Eckhart Tolle",
      image: "assets/podcast/salud-mental/Un-poco-mejor.png",
      link: "https://youtu.be/dwM9LdMGlJM?si=aSuSC9hacek_LX8w",
      description:
          "En este episodio, UN POCO MEJOR explora el poder del momento presente y ofrece consejos prácticos para dejar de" +
              " preocuparse demasiado por el pasado o el futuro. El podcast se basa en las enseñanzas de Eckhart Tolle sobre la" +
              " importancia de la atención plena y la presencia en nuestras vidas."),
  cardsdata(
      id: 5,
      categoria: "Salud Mental",
      autor: "Tengo un Plan",
      name:
          "7 Hábitos para Vivir +100 Años y Cuidar tu Salud (Doctor #1 Anti-Envejecimiento)",
      image: "assets/podcast/salud-mental/Tengo-un-plan.jpg",
      link: "https://youtu.be/7RsDc6Qy8t8?si=b1MQ3LH5QW2a6bBU",
      description:
          "TENGO UN PLAN presenta una guía para adoptar hábitos saludables que pueden ayudar a prolongar la vida y mejorar la" +
              " salud en general. El podcast ofrece consejos prácticos de un experto en anti-envejecimiento y promueve un enfoque" +
              " integral para cuidar el cuerpo y la mente a lo largo de la vida."),
  cardsdata(
      id: 1,
      categoria: "Desarrollo Personal",
      autor: "Pedro Buerbaum",
      name: "7 Hábitos para Mejorar Tu Vida",
      image: "assets/podcast/desarrollo-personal/Pedro.png",
      link: "https://youtu.be/0H7s9I-3BLU?si=dO_ZUdTLDYGewZe0",
      description:
          "En este podcast, Pedro Buerbaum comparte siete hábitos fundamentales que pueden transformar positivamente tu vida." +
              " Desde la gestión del tiempo hasta el desarrollo de habilidades interpersonales, este episodio ofrece consejos prácticos" +
              " y motivación para impulsar tu crecimiento personal y alcanzar tus objetivos."),
  cardsdata(
      id: 2,
      categoria: "Desarrollo Personal",
      autor: "Daniel Castrejón",
      name: "Cómo EMPEZAR tu proceso de DESARROLLO PERSONAL",
      image: "assets/podcast/desarrollo-personal/DanielCastrejon.png",
      link: "https://youtu.be/_2_jyG5DOd0?si=CHwWGHJUtLNkZ5WY",
      description:
          "En este episodio, Daniel Castrejón brinda orientación sobre cómo dar los primeros pasos en tu viaje de desarrollo personal." +
              " Desde la autoevaluación hasta la planificación de metas, este podcast ofrece herramientas y recursos para iniciar un proceso " +
              " de crecimiento personal significativo y transformador."),
  cardsdata(
      id: 3,
      categoria: "Desarrollo Personal",
      autor: "Jim Rohn",
      name: "Filosofía para tu desarrollo personal",
      image: "assets/podcast/desarrollo-personal/JimRohn.png",
      link: "https://youtu.be/wJMgLZGG3AA?si=Tf1ZdEnO5gOBIOCf",
      description:
          "Jim Rohn comparte su filosofía única sobre el desarrollo personal en este podcast inspirador. Explora ideas y conceptos" +
              " fundamentales que pueden impulsar tu crecimiento personal y ayudarte a alcanzar tu máximo potencial. Este episodio ofrece" +
              " una perspectiva profunda y práctica sobre cómo mejorar tu vida."),
  cardsdata(
      id: 4,
      categoria: "Desarrollo Personal",
      autor: "Euge Oller y Alessandro Castro",
      name: "Cómo Mejorar Personal y Profesionalmente en 40 Minutos",
      image: "assets/podcast/desarrollo-personal/EugeOller.png",
      link: "https://youtu.be/DfFHOTel0cw?si=k8kBbLaWc7ospoE3",
      description:
          "En este episodio, Euge Oller y Alessandro Castro comparten estrategias prácticas para mejorar tanto en el ámbito personal" +
              " como en el profesional. Desde el desarrollo de habilidades hasta la gestión del tiempo, este podcast ofrece consejos útiles" +
              " y motivación para alcanzar el éxito en todas las áreas de tu vida."),
  cardsdata(
      id: 5,
      categoria: "Desarrollo Personal",
      autor: "Valeria Machuca",
      name:
          "ES PARTE DE CRECER: empezar a ser adulto, ser distintas versiones de ti mismo, extrañar el pasado",
      image: "assets/podcast/desarrollo-personal/Valeria.png",
      link: "https://youtu.be/3j_82V3a3Vc?si=_WyQanKmBL5LN9ME",
      description:
          "Valeria Machuca aborda temas profundos relacionados con el crecimiento personal y el desarrollo emocional en este podcast" +
              " reflexivo. Desde la aceptación del cambio hasta el proceso de maduración, este episodio ofrece una visión perspicaz y" +
              " conmovedora sobre los desafíos y las alegrías de crecer como persona."),
  cardsdata(
      id: 1,
      categoria: "Bienestar Físico",
      autor: "Joel Jimenez",
      name: "ANTILLEAN PODCAST | Saludablemente: Bienestar Físico",
      image: "assets/podcast/bienestar-fisico/Antillean.png",
      link: "https://youtu.be/FJBmKjsmu_E?si=wA_k85iMD-yk3mJo",
      description:
          "En este podcast, Joel Jimenez aborda temas relacionados con el bienestar físico y la salud en general. Desde consejos de" +
              " ejercicio hasta hábitos de vida saludable, este episodio ofrece información y motivación para mejorar tu condición física" +
              " y promover un estilo de vida activo y equilibrado."),
  cardsdata(
      id: 2,
      categoria: "Bienestar Físico",
      autor: "Beatríz Luengo",
      name: "Como influye la mente en nuestra salud o enfermedad",
      image: "assets/podcast/bienestar-fisico/Beatriz.png",
      link: "https://youtu.be/tH5ZbNZBs0k?si=Y80GSu7gNjRYDgmF",
      description:
          "Beatríz Luengo explora la conexión entre la mente y el cuerpo en este podcast revelador. Desde el impacto del estrés en la" +
              " salud hasta la importancia de una mentalidad positiva, este episodio ofrece una comprensión más profunda de cómo nuestros" +
              " pensamientos y emociones influyen en nuestra salud y bienestar general."),
  cardsdata(
      id: 3,
      categoria: "Bienestar Físico",
      autor: "Carlos Fernandez, Sarah, Samanta",
      name: "Me Da Flojera Hacer Ejercicio | Podcast 06 |",
      image: "assets/podcast/bienestar-fisico/Carlos.png",
      link: "https://youtu.be/nUQlmWkyMQE?si=zT99jRsoLv3FjsfA",
      description:
          "En este podcast, Carlos Fernandez, Sarah, y Samanta abordan el tema de la pereza al hacer ejercicio y ofrecen consejos" +
              " prácticos para superarla. Desde la motivación hasta la planificación de entrenamientos, este episodio proporciona estrategias" +
              " útiles para vencer la pereza y adoptar un estilo de vida activo y saludable."),
  cardsdata(
      id: 4,
      categoria: "Bienestar Físico",
      autor: "Alba Novoa",
      name: "CÓMO EMPEZAR A ENTRENAR para MEJORAR tu FÍSICO y SALUD",
      image: "assets/podcast/bienestar-fisico/Alba.png",
      link: "https://youtu.be/YURLkNQJAss?si=VUDfjEw_ZhcKTq6p",
      description:
          "Alba Novoa comparte consejos prácticos para comenzar un programa de entrenamiento efectivo en este podcast motivador. Desde la" +
              " elección de ejercicios hasta la creación de rutinas de ejercicio, este episodio ofrece orientación paso a paso para mejorar tu" +
              " condición física y promover una vida más saludable."),
  cardsdata(
      id: 5,
      categoria: "Bienestar Físico",
      autor: "Jesús López",
      name: "CONSIGUE un CUERPO en FORMA y ATLÉTICO - Podcast",
      image: "assets/podcast/bienestar-fisico/Jesus.png",
      link: "https://youtu.be/td8shd41w1g?si=IiJ2-ftDLd7Y04Yr",
      description:
          "En este podcast, Jesús López comparte estrategias efectivas para alcanzar un cuerpo en forma y atlético. Desde consejos de" +
              " entrenamiento hasta recomendaciones de nutrición, este episodio proporciona información valiosa y motivación para ayudarte a" +
              " alcanzar tus objetivos de fitness y mejorar tu salud física en general."),
];
