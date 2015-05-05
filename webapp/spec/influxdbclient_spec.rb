module Bolt
  describe InfluxDBClient do
    let(:a_serie) { 'test_values' }
    let(:a_value) { 42 }

    before(:each) do
      @influxdb = InfluxDBClient.new('bolt_test')
    end

    after(:each) do
      @influxdb.delete_series(a_serie)
    end

    it 'writes a point' do
      @influxdb.write_point(a_serie, {:value => a_value})

      result = @influxdb.query("select * from #{a_serie}")

      expect(result.length).to eq(1)
    end

    it 'queries for an aggregate' do
      max_value = a_value * 2

      @influxdb.write_point(a_serie, {:value => max_value})
      @influxdb.write_point(a_serie, {:value => a_value})

      result = @influxdb.query("select max(value) from #{a_serie}")

      expect(result.length).to eq(1)
      expect(result[0]['max']).to eq(max_value)
    end

    it 'queries for non existent aggregate' do
      @influxdb.write_point(a_serie, {:value => a_value})
      @influxdb.write_point(a_serie, {:value => a_value + 1})

      result = @influxdb.query("select mean(value) from #{a_serie} where time < #{Date.today - 1}")

      expect(result.length).to eq(0)
    end
  end
end
