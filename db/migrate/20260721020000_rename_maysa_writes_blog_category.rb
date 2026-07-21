class RenameMaysaWritesBlogCategory < ActiveRecord::Migration[8.0]
  def up
    execute "UPDATE blogs SET category = 'clinic_notes' WHERE category = 'maysa_writes'"
  end

  def down
    execute "UPDATE blogs SET category = 'maysa_writes' WHERE category = 'clinic_notes'"
  end
end
