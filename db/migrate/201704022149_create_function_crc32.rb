class CreateFunctionCrc32 < ActiveRecord::Migration[4.2]
  def up
    ActiveRecord::Base.connection.execute <<~SQL
      CREATE FUNCTION crc32(text_string text) RETURNS bigint AS $$
      DECLARE
          tmp bigint;
          i int;
          j int;
          byte_length int;
          binary_string bytea;
      BEGIN
          IF text_string IS NULL THEN
              RETURN null;
          END IF;
          IF text_string = '' THEN
              RETURN 0;
          END IF;

          i = 0;
          tmp = 4294967295;
          byte_length = bit_length(text_string) / 8;
          binary_string = decode(replace(text_string, E'\\\\', E'\\\\\\\\'), 'escape');
          LOOP
              tmp = (tmp # get_byte(binary_string, i))::bigint;
              i = i + 1;
              j = 0;
              LOOP
                  tmp = ((tmp >> 1) # (3988292384 * (tmp & 1)))::bigint;
                  j = j + 1;
                  IF j >= 8 THEN
                      EXIT;
                  END IF;
              END LOOP;
              IF i >= byte_length THEN
                  EXIT;
              END IF;
          END LOOP;
          RETURN (tmp # 4294967295);
      END
      $$ IMMUTABLE LANGUAGE plpgsql;
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP FUNCTION crc32(text_string text)'
  end
end
