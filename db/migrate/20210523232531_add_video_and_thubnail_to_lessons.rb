class AddVideoAndThubnailToLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :video, :string
    add_column :lessons, :thumbnail, :string
  end
end
