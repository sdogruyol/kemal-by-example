class MetricSnapshot
  include DB::Serializable

  getter id : Int64?
  getter cpu_percent : Float64
  getter memory_percent : Float64
  getter created_at : String

  def initialize(
    @cpu_percent : Float64,
    @memory_percent : Float64,
    @created_at : String = Time.local.to_s("%H:%M:%S"),
    @id : Int64? = nil
  )
  end

  def self.record(cpu_percent : Float64, memory_percent : Float64) : MetricSnapshot
    created_at = Time.local.to_s("%H:%M:%S")

    RealTimeDashboard::Database.connection.exec(
      "INSERT INTO metric_snapshots (cpu_percent, memory_percent, created_at) VALUES (?, ?, ?)",
      cpu_percent,
      memory_percent,
      created_at
    )

    id = RealTimeDashboard::Database.connection.query_one(
      "SELECT last_insert_rowid()",
      as: Int64
    )

    find(id).not_nil!
  end

  def self.find(id : Int64) : MetricSnapshot?
    RealTimeDashboard::Database.connection.query_one?(
      "SELECT id, cpu_percent, memory_percent, created_at FROM metric_snapshots WHERE id = ?",
      id,
      as: MetricSnapshot
    )
  end

  def self.recent(limit : Int32 = 30) : Array(MetricSnapshot)
    RealTimeDashboard::Database.connection.query_all(
      "SELECT id, cpu_percent, memory_percent, created_at FROM metric_snapshots ORDER BY id DESC LIMIT ?",
      limit,
      as: MetricSnapshot
    ).reverse
  end

  def self.prune(limit : Int32 = 120)
    RealTimeDashboard::Database.connection.exec(
      "DELETE FROM metric_snapshots WHERE id NOT IN (SELECT id FROM metric_snapshots ORDER BY id DESC LIMIT ?)",
      limit
    )
  end

  def to_payload
    {
      id: id,
      cpu_percent: cpu_percent.round(2),
      memory_percent: memory_percent.round(2),
      created_at: created_at,
    }
  end
end
