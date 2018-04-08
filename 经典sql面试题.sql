#1.查询“001”课程比“002”课程成绩高的所有学生的学号
#子查询
SELECT 
    s1.id, s1.name
FROM
    (SELECT 
        *
    FROM
        text.student, text.score
    WHERE
        score.cid = '1'
            AND student.id = score.sid) AS s1,
    (SELECT 
        *
    FROM
        text.student, text.score
    WHERE
        score.cid = '2'
            AND student.id = score.sid) AS s2
WHERE
    s1.sid = s2.sid AND s1.score > s2.score;

#2、查询平均成绩大于60分的同学的学号,姓名和平均成绩
#聚合，Having子句
SELECT 
    name, sid, AVG(score)
FROM
    text.student,
    text.score
WHERE
    student.id = score.sid
GROUP BY score.sid
HAVING AVG(score) > 60;

#3、查询所有同学的学号、姓名、选课数、总成绩
#聚合函数sum，聚合
SELECT 
    sid, name, COUNT(cid), SUM(score)
FROM
    text.score,
    text.student
WHERE
    student.id = score.sid
GROUP BY score.sid; 

#4、查询姓‘李’的老师的个数：
#聚合函数count，LIKE谓词
SELECT 
    COUNT(*)
FROM
    text.teacher AS te
WHERE
    te.name LIKE '李%'; 

#5、查询没有学过“叶平”老师可的同学的学号、姓名：
#使用子查询作为in谓词的参数
SELECT 
    student.id, student.name
FROM
    text.student
WHERE
    student.id NOT IN (SELECT 
            score.sid
        FROM
            text.course,
            text.teacher,
            text.score
        WHERE
            course.tid = teacher.id
                AND course.id = score.cid
                AND teacher.name = '王锁柱'); 

#6、查询学过“叶平”老师所教的所有课的同学的学号、姓名：
SELECT 
    student.id, student.name
FROM
    text.student
WHERE
    student.id IN (SELECT 
            score.sid
        FROM
            text.course,
            text.teacher,
            text.score
        WHERE
            course.tid = teacher.id
                AND course.id = score.cid
        GROUP BY score.sid
        HAVING COUNT(score.cid) = (SELECT 
                COUNT(course.id)
            FROM
                text.course,
                text.teacher
            WHERE
                teacher.id = course.id
                    AND teacher.name = '李山'));

#7、查询学过“011”并且也学过编号“002”课程的同学的学号、姓名：
#Exists
SELECT 
    s1.id, s1.name
FROM
    (SELECT 
        *
    FROM
        text.score, text.student
    WHERE
        score.sid = student.id
            AND score.cid = '1') AS s1,
    (SELECT 
        *
    FROM
        text.score, text.student
    WHERE
        score.sid = student.id
            AND score.cid = '1') AS s2
WHERE
    s1.sid = s2.sid; 

#8、查询课程编号“002”的成绩比课程编号“001”课程低的所有同学的学号、姓名：

#9、查询所有课程成绩小于60的同学的学号、姓名：
SELECT 
    student.name, student.id
FROM
    text.student
WHERE
    student.id NOT IN (SELECT 
            student.id
        FROM
            text.student,
            text.score
        WHERE
            student.id = score.sid AND score > 60);

#10、查询没有学全所有课的同学的学号、姓名：
SELECT 
    st.name, st.id
FROM
    text.student AS st
WHERE
    st.id IN (SELECT 
            score.sid
        FROM
            text.score
        GROUP BY score.sid
        HAVING COUNT(score.cid) < (SELECT 
                COUNT(course.id)
            FROM
                text.course));

#11、查询至少有一门课与学号为“1001”同学所学相同的同学的学号和姓名：
SELECT 
    st.name, st.id
FROM
    text.student AS st,
    text.score AS sc
WHERE
    st.id = sc.sid
GROUP BY sc.sid
HAVING sc.cid IN (SELECT 
        score.cid
    FROM
        text.score
    WHERE
        score.sid = '1');

#12、查询至少学过学号为“001”同学所有一门课的其他同学学号和姓名；

#14、查询和“1002”号的同学学习的课程完全相同的其他同学学号和姓名：

#16、向SC表中插入一些记录，这些记录要求符合以下条件：没有上过编号“003”课程的同学学号、002号课的平均成绩：
  

#40.查询选修“叶平”老师所授课程的学生中，成绩最高的学生姓名及其成绩：
#标量子查询
SELECT 
    st.name, so.score
FROM
    text.score AS so,
    text.student AS st,
    text.teacher AS te,
    text.course AS co
WHERE
    st.id = so.sid AND so.cid = co.id
        AND co.tid = te.id
        AND te.name = '李山'
        AND so.score = (SELECT 
            MAX(score)
        FROM
            text.score,
            text.course
        WHERE
            score.cid = course.id);
 
#42、查询不同课程成绩相同的学生和学号、课程号、学生成绩：
SELECT 
    a.score, a.sid, a.cid
FROM
    score AS a,
    score AS b
WHERE
    a.score = b.score AND a.cid <> b.cid;

#47、查询没学过”叶平”老师讲授的任一门课程的学生姓名：
SELECT 
    student.name
FROM
    student
WHERE
    student.id NOT IN (SELECT 
            score.sid
        FROM
            score,
            teacher,
            course
        WHERE
            score.cid = course.id
                AND teacher.id = course.tid
                AND teacher.name = '郝磊');

#48、查询两门以上不及格课程的同学的学号以及其平均成绩:
SELECT 
    sid, AVG(score)
FROM
    score
WHERE
    (SELECT 
            COUNT(cid)
        FROM
            score
        WHERE
            score < 80) > 2
GROUP BY sid;

#49、检索“004”课程分数小于60，按分数降序排列的同学学号：
SELECT 
    sid, score, cid
FROM
    score
WHERE
    score < 90 AND cid = '1'
ORDER BY score DESC;