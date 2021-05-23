class AddLogoToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :logo, :string
  end
end
