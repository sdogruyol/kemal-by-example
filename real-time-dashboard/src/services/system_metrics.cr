module RealTimeDashboard
  module SystemMetrics
    extend self

    def collect : MetricSnapshot
      cpu_channel = Channel(Float64).new
      memory_channel = Channel(Float64).new

      spawn { cpu_channel.send(cpu_percent) }
      spawn { memory_channel.send(memory_percent) }

      MetricSnapshot.new(
        cpu_percent: cpu_channel.receive,
        memory_percent: memory_channel.receive
      )
    end

    private def cpu_percent : Float64
      output = darwin? ? run_command("top", "-l", "1", "-n", "0") : run_command("top", "-b", "-n", "1")

      idle = output.match(/(\d+(?:\.\d+)?)%\s*idle/).try(&.[1].to_f64) || 0.0
      clamp(100.0 - idle)
    rescue
      0.0
    end

    private def memory_percent : Float64
      if darwin?
        output = run_command("top", "-l", "1", "-n", "0")
        used = output.match(/PhysMem:\s+([0-9\.A-Z]+)\s+used/i).try { |m| parse_size_to_bytes(m[1]) } || 0_f64
        unused = output.match(/,\s+([0-9\.A-Z]+)\s+unused/i).try { |m| parse_size_to_bytes(m[1]) } || 0_f64
        total = used + unused
        return total > 0 ? clamp((used / total) * 100.0) : 0.0
      end

      output = run_command("free", "-b")
      line = output.lines.find(&.starts_with?("Mem:")) || ""
      parts = line.split
      total = parts[1]?.try(&.to_f64) || 0_f64
      used = parts[2]?.try(&.to_f64) || 0_f64

      total > 0 ? clamp((used / total) * 100.0) : 0.0
    rescue
      0.0
    end

    private def run_command(*command : String) : String
      io = IO::Memory.new
      Process.run(command[0], command[1..], output: io, error: io)
      io.to_s
    end

    private def parse_size_to_bytes(value : String) : Float64
      match = value.strip.upcase.match(/([0-9.]+)([KMGTP]?)/)
      return 0_f64 unless match

      amount = match[1].to_f64
      unit = match[2]

      case unit
      when "T" then amount * 1024_f64 * 1024_f64 * 1024_f64 * 1024_f64
      when "G" then amount * 1024_f64 * 1024_f64 * 1024_f64
      when "M" then amount * 1024_f64 * 1024_f64
      when "K" then amount * 1024_f64
      else          amount
      end
    end

    private def clamp(value : Float64) : Float64
      return 0.0 if value.nan? || value.infinite?
      return 0.0 if value < 0.0
      return 100.0 if value > 100.0

      value
    end

    private def darwin? : Bool
      {% if flag?(:darwin) %}
        true
      {% else %}
        false
      {% end %}
    end
  end
end
