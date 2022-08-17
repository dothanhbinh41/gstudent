import 'package:gstudent/api/dtos/Clan/clan.dart';

class CourseModel {
  CourseModel(
      {this.id,
      this.courseId,
      this.studentId,
      this.classroomId,
      this.classroom,
      this.course,
      this.isLearning,
      this.clan});

  int id;
  int courseId;
  int studentId;
  int classroomId;
  Classroom classroom;
  CourseCourse course;
  bool isLearning;
  Clan clan;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json["id"] != null ? json["id"] : null,
        courseId: json["course_id"],
        studentId: json["student_id"],
        classroomId: json["classroom_id"],
        classroom: json["classroom"] != null
            ? Classroom.fromJson(json["classroom"])
            : null,
        course: json["course"] != null
            ? CourseCourse.fromJson(json["course"])
            : null,
        isLearning: json["is_learning"],
        clan: json["clan"] != null ? Clan.fromJson(json["clan"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id != null ? id : clan,
        "course_id": courseId,
        "student_id": studentId,
        "classroom_id": classroomId,
        "classroom": classroom != null ? classroom.toJson() : null,
        "course": course != null ? course.toJson() : null,
        "is_learning": isLearning,
        "clan": clan != null ? clan.toJson() : null,
      };
}

class Classroom {
  Classroom({
    this.id,
    this.name,
    this.courseId,
    this.startTime,
    this.lesson,
    this.dateStart,
    this.finishTime,
  });

  int id;
  String name;
  int courseId;
  DateTime startTime;
  String lesson;
  DateTime dateStart;
  DateTime finishTime;

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
        id: json["id"],
        name: json["name"],
        courseId: json["course_id"],
        startTime: json["start_time"] != null
            ? DateTime.parse(json["start_time"])
            : DateTime.now().add(-Duration(days: 365)),
        lesson: json["lesson"],
        dateStart: json["start_time"] != null
            ? DateTime.parse(json["start_time"])
            : DateTime.now().add(-Duration(days: 365)),
        finishTime: json["finish_time"] != null
            ? DateTime.parse(json["finish_time"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "course_id": courseId,
        "start_time": startTime != null ? startTime.toIso8601String() : null,
        "lesson": lesson,
        "date_start": dateStart.toIso8601String(),
        "finish_time": finishTime != null ? finishTime.toIso8601String() : null,
      };
}

class CourseCourse {
  CourseCourse({
    this.id,
    this.name,
    this.islandId,
  });

  int id;
  String name;
  int islandId;

  factory CourseCourse.fromJson(Map<String, dynamic> json) => CourseCourse(
        id: json["id"],
        name: json["name"],
        islandId: json["island_id"] != null ? json["island_id"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "island_id": islandId,
      };
}
