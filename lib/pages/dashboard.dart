import 'package:flutter/material.dart';
import '../components/course/course_master.dart';

/// First page to open, displays app goals and a list of popular courses
/// seperated by type.
/// Each type provides an option to see all courses.
class HomePage extends StatelessWidget {
  ///
  const HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('IT Operations'),
                trailing: TextButton(
                  child: Text('See all'),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                    CourseMaster(
                      size: 1.6,
                      title: 'course title',
                      level: 'beginner',
                      views: 888,
                      author: 'The Author',
                      upload: DateTime.now(),
                      rating: 5,
                      thumbnail:
                          'https://images.dog.ceo/breeds/leonberg/n02111129_1482.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
