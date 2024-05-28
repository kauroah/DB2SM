CREATE TABLE IF NOT EXISTS Students (
                                        StudentID INT PRIMARY KEY,
                                        studentName VARCHAR(255),
                                        groupId INT,
                                        FOREIGN KEY (groupId) REFERENCES Groups(groupId)
);

-- Create the Groups table
CREATE TABLE Groups (
                                      groupId INT PRIMARY KEY,
                                      GroupName VARCHAR(255)
);

-- Create the Courses table
CREATE TABLE IF NOT EXISTS Courses (
                                       CourseId INT PRIMARY KEY,
                                       CourseName VARCHAR(255)
);

-- Create the Lecturers table
CREATE TABLE IF NOT EXISTS Lecturers (
                                         LecturerId INT PRIMARY KEY,
                                         LecturerName VARCHAR(255)
);

-- Create the Plan table
CREATE TABLE IF NOT EXISTS Plan (
                                    GroupId INT,
                                    CourseId INT,
                                    LecturerId INT,
                                    PRIMARY KEY (GroupId, CourseId),
                                    FOREIGN KEY (GroupId) REFERENCES Groups(groupId),
                                    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
                                    FOREIGN KEY (LecturerId) REFERENCES Lecturers(LecturerId)
);

-- Create the Marks table
CREATE TABLE IF NOT EXISTS Marks (
                                     StudentId INT,
                                     CourseId INT,
                                     Mark INT,
                                     PRIMARY KEY (StudentId, CourseId),
                                     FOREIGN KEY (StudentId) REFERENCES Students(StudentID),
                                     FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);


-- Insert sample data into Groups table
INSERT INTO Groups (groupId, GroupName) VALUES
                                            (1, 'Group A'),
                                            (2, 'Group B'),
                                            (3, 'Group C');

-- Insert sample data into Courses table
INSERT INTO Courses (CourseId, CourseName) VALUES
                                               (1, 'Mathematics'),
                                               (2, 'Physics'),
                                               (3, 'Chemistry');

-- Insert sample data into Lecturers table
INSERT INTO Lecturers (LecturerId, LecturerName) VALUES
                                                     (1, 'Dr. Smith'),
                                                     (2, 'Prof. Johnson'),
                                                     (3, 'Dr. Brown');

-- Insert sample data into Students table
INSERT INTO Students (StudentID, studentName, groupId) VALUES
                                                           (101, 'John Doe', 1),
                                                           (102, 'Jane Smith', 2),
                                                           (103, 'Michael Johnson', 3);

-- Insert sample data into Plan table
INSERT INTO Plan (GroupId, CourseId, LecturerId) VALUES
                                                     (1, 1, 1),
                                                     (2, 2, 2),
                                                     (3, 3, 3);

-- Insert sample data into Marks table
INSERT INTO Marks (StudentId, CourseId, Mark) VALUES
                                                  (101, 1, 85),
                                                  (102, 2, 78),
                                                  (103, 3, 90);


-- Replace specified_ID with the actual student ID you want to search for
SELECT StudentID, studentName, groupId
FROM Students
WHERE StudentID = 101;

-- Replace specified_full_NAME with the actual full name of the student you want to search for
SELECT s.StudentID, s.studentName, g.GroupName
FROM Students s
         JOIN Groups g ON s.groupId = g.groupId
WHERE s.studentName = 'John Doe';



-- Replace given_grade with the actual grade value and specified_ID with the actual course ID
SELECT m.StudentID, s.studentName, s.groupId
FROM Marks m
         JOIN Students s ON m.StudentID = s.StudentID
WHERE m.Mark = 85 AND m.CourseId = 1;



-- Replace specified_discipline with the actual course name
SELECT s.StudentID, s.studentName, s.groupId
FROM Students s
WHERE s.StudentID NOT IN (SELECT m.StudentID FROM Marks m JOIN Courses c ON m.CourseId = c.CourseId WHERE c.CourseName = 'Mathematics');


SELECT s.studentName, c.CourseName
FROM Students s
         JOIN Plan p ON s.groupId = p.GroupId
         JOIN Courses c ON p.CourseId = c.CourseId;


-- Replace specified_teacher_name with the actual lecturer name
SELECT DISTINCT m.StudentID
FROM Marks m
         JOIN Plan p ON m.CourseId = p.CourseId
         JOIN Lecturers l ON p.LecturerId = l.LecturerId
WHERE l.LecturerName = 'Dr. Smith';
