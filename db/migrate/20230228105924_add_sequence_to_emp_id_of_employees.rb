# frozen_string_literal: true

class AddSequenceToEmpIdOfEmployees < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up { reversible_up }
      dir.down { reversible_down }
    end
  end

  private

  def reversible_up
    execute <<-SQL.squish
      CREATE SEQUENCE employees_emp_id_seq START 1000;
      ALTER TABLE employees ALTER COLUMN emp_id SET DEFAULT nextval('employees_emp_id_seq');
    SQL
  end

  def reversible_down
    execute <<-SQL.squish
      ALTER TABLE employees ALTER COLUMN emp_id SET DEFAULT NULL;
      DROP SEQUENCE employees_emp_id_seq;
    SQL
  end
end
