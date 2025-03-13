import 'package:flutter/material.dart';

import '../books/book_model.dart';

final List<BookModel> books = [
  BookModel(
      id: 1,
      name: 'Crime and Punishment',
      author: 'Fyodor Dostoevsky',
      imagePath:'images/fyodor.jpg',
      // NetworkImage(
      //     'https://www.simbasible.com/wp-content/uploads/2020/12/22-8-1024x1541.jpg'),
      description:
      'Crime and Punishment follows the mental anguish and moral dilemmas of Rodion Raskolnikov, an impoverished ex-student in Saint Petersburg who plans to kill an unscrupulous pawnbroker, an old woman who stores money and valuable objects in her flat. He theorises that with the money he could liberate himself from poverty and go on to perform great deeds, and seeks to convince himself that certain crimes are justifiable if they are committed in order to remove obstacles to the higher goals of "extraordinary" men. Once the deed is done, however, he finds himself wracked with confusion, paranoia, and disgust. His theoretical justifications lose all their power as he struggles with guilt and horror and is confronted with both internal and external consequences of his deed.'
  ),
  BookModel(
    id: 2,
    name: 'The Hunchback of notre dame',
    author: 'Victor Hugo',
    imagePath:'images/hugo.jpg',
    description:'The Hunchback of Notre Dame is a novel by Victor Hugo that was first published in 1831 (as Notre-Dame de Paris). One of the first great novels of the Romantic era, it has entertained generations of readers with its powerfully melodramatic story of Quasimodo, the hunchback who lives in the bell tower of medieval Paris’s most famous cathedral. An epic tale of beauty and sadness, The Hunchback of Notre Dame portrays the sufferings of humanity with compassion and power.',
  ),
  BookModel(
    id: 3,
    name: 'The Strange',
    author: 'Albert Camus',
    imagePath:'images/albert.jpg',
    description:'The Stranger is a novel by Albert Camus, published in 1942. It follows the life of Meursault, a French Algerian whose apathetic responses to life get him in trouble socially and eventually get him killed. The novel is famous for its first lines: “Mother died today. Or maybe it was yesterday, I don’t know.” They capture Meursault’s anomie briefly and brilliantly. After this introduction, the reader follows Meursault through the novel’s first-person narration to Marengo, where he sits vigil at the place of his mother’s death. Despite the expressions of grief around him during his mother’s funeral, Meursault does not show any outward signs of distress. This removed nature continues throughout all of Meursault’s relationships, both platonic and romantic.',
  ),
  BookModel(
    id: 4,
    name: 'Madonna in a Fur Coat',
    author: 'Sabahattin Ali',
    imagePath:'images/madonna.jpg',
    description: 'Madonna in a Fur Coat (Turkish: Kürk Mantolu Madonna) is a novel written by Turkish author Sabahattin Ali. It was published in 1943.The book tells the story of Raif, who is living a purposeless life until he meets a woman named Maria Puder. Initially, the book was criticized by many critics because it was just another love story but it became a bestseller in time, and is usually recalled among the best works in Turkish literature.It was translated to English by Maureen Freely in 2016,The novel delves into the complexities of their intense, yet fragile relationship, exploring themes of unfulfilled dreams, the quest for human connection, and the emotional struggles that shape who we are. It is a reflection on how love can both uplift and devastate us, while also serving as a critique of societal norms and expectations. ',
  ),
  BookModel(
      id: 5,
      name:  'Utopia',
      author:'Ahmed Khaled Tawfik',
      imagePath:'images/utopia.jpg',
      description:'Utopia by Ahmed Khaled Tawfik is a dystopian novel first published in 2008. Set in the year 2023, it portrays a starkly divided Egypt, where the wealthy elite live in a luxurious, walled-off city called Utopia, guarded by Marines. Outside these walls, the rest of the population struggles in extreme poverty, residing in slums and fighting for survival. The novel is a gripping critique of class disparity and societal decay, blending suspense with thought-provoking commentary. It has been widely praised for its vivid storytelling and remains a significant work in modern Arabic literature.'
  ),
];