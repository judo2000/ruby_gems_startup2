require "test_helper"

class EnrollmentMailerTest < ActionMailer::TestCase
  def student_enrollment 
    EnrollmentMailer.student_enrollment(Enrollment.first).deliver_now
  end

  def teacher_enrollment 
    EnrollmentMailer.teacher_enrollment(Enrollment.first).deliver_now
  end
end
