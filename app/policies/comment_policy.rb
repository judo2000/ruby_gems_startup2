class CommentPolicy < ApplicationPolicy  
 
  def destroy?
    @record.lesson.course.user_id == @user.id ||
    @record.user == @user ||
    @user.has_role?(:admin)
  end
end
