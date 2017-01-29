require 'docking_station'

describe DockingStation do
  describe '#release_bike' do
    # Remove dependency on bike
    let(:bike) { double :bike }

    it 'responds to release_bike' do
      expect(subject).to respond_to :release_bike
    end

    it 'releases working bikes' do
      allow(bike).to receive(:working?).and_return(true)
      allow(bike).to receive(:broken?).and_return(false)
      subject.dock(bike)
      expect(subject.release_bike).to be_working
    end

    it 'raises an error when no bikes are available' do
      docking_station = DockingStation.new
      expect { docking_station.release_bike }.to raise_error 'No bikes available'
    end

    it 'raises an error if the only bike available is broken' do
      allow(bike).to receive(:working?).and_return(false)
      allow(bike).to receive(:broken?).and_return(true)
      docking_station = DockingStation.new
      docking_station.dock bike
      expect { docking_station.release_bike }.to raise_error 'No bikes available'
    end
  end

  describe '#dock' do
    it { is_expected.to respond_to(:dock).with(1).argument }

    it 'docks something' do
      bike = Bike.new
      # Return the bike we dock
      expect(subject.dock(bike)).to eq [bike]
    end

    it 'raises an error when full' do
      subject.capacity.times { subject.dock double :bike }
      expect { subject.dock double :bike }.to raise_error 'Docking station full'
    end

    it 'docks a broken bike' do
      bike = Bike.new
      bike.report_broken
      expect(subject.dock(bike)).to eq [bike]
    end
  end

  describe '#bikes' do
    it { is_expected.to respond_to(:bikes) }

    it 'returns docked bikes' do
      bike = Bike.new
      subject.dock(bike)
      expect(subject.bikes).to eq [bike]
    end
  end

  describe '#capacity' do
    it 'has a default capacity' do
      expect(subject.capacity).to eq DockingStation::DEFAULT_CAPACITY
    end
  end

  describe 'initialization' do
    it 'has a variable capacity' do
      docking_station = DockingStation.new(50)
      50.times { docking_station.dock Bike.new }
      expect{ docking_station.dock Bike.new }.to raise_error 'Docking station full'
    end
  end

end
