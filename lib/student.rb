require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name, @grade = name, grade
    @id = id
  end


  def self.create_table
   sql =  <<-SQL
     CREATE TABLE IF NOT EXISTS students (
       id INTEGER PRIMARY KEY,
       name TEXT,
       grade TEXT
       )
       SQL
   DB[:conn].execute(sql)
 end

 def self.drop_table
   sql = <<-SQL
    DROP TABLE students
    SQL
  DB[:conn].execute(sql)
 end

 def save
   sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
  DB[:conn].execute(sql, self.name, self.grade)
  @id = DB[:conn].execute("SELECT students.id FROM students WHERE students.name = name").flatten[0]
 end

 def self.create name:, grade:
   new_student = Student.new(name, grade)
   new_student.save
   new_student
 end

end
