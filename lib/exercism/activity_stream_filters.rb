module ActivityStream
  module Filter
    def items
      @items ||= execute(sql).map do |row|
        item(row["id"], row["total"])
      end.sort(&order).each do |item|
        item.unread = unread(item)
      end
    end

    protected

    def unread(item)
      [item.total - read(item.id), 0].max
    end

    def read(id)
      views_by_id[id] + watermarked_by_id[id]
    end

    # By default, don't bother changing the order.
    def order
      proc { 0 }
    end

    def views_by_id
      @views_by_id ||= execute(views_sql).each_with_object(Hash.new(0)) do |row, views|
        views[row["id"]] = row["total"].to_i
      end
    end

    def watermarked_by_id
      @watermarked_by_id ||= execute(watermarks_sql).each_with_object(Hash.new(0)) do |row, watermarked|
        watermarked[row["id"]] = row["total"].to_i
      end
    end

    def watermarks_sql
      ""
    end

    def execute(query)
      ActiveRecord::Base.connection.execute(query).to_a
    end
  end
end
