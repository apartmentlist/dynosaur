describe Dynosaur::Process::Local do
  describe '#running?' do
    subject { Dynosaur::Process::Local.new(task: 'fake:task', args: %w[foo bar]) }

    let(:response) { [true, false].sample }
    let(:finder) do
      instance_double(Dynosaur::Process::Local::Finder, exists?: response)
    end

    before do
      rake_command =
        Dynosaur::Utils::RakeCommand.new(task: 'fake:task', args: %w[foo bar])
      allow(Dynosaur::Process::Local::Finder).to receive(:new)
        .with(rake_command: rake_command).and_return(finder)
    end

    it 'returns the value from Finder#exists?' do
      expect(subject.running?).to eq(finder.exists?)
    end
  end

  describe '#start' do
    subject { Dynosaur::Process::Local.new(task: task, args: args) }

    let(:task) { 'fake:task' }
    let(:args) { [] }

    before do
      allow(Process).to receive(:spawn).and_return(38)
      allow(Process).to receive(:detach)
    end

    it 'runs the task in a new process' do
      command = 'rake fake:task --trace'
      expect(Process).to receive(:spawn).with(command).and_return(38)
      subject.start
    end

    it 'detaches from the process' do
      expect(Process).to receive(:detach).with(38)
      subject.start
    end

    it 'returns the process identifier' do
      expect(subject.start).to eq(38)
    end

    context 'when args are passed to the rake task' do
      let(:args) { ['Hello World', 1999] }

      it 'adds the arguments to the rake task' do
        command = 'rake fake:task[Hello\\ World,1999] --trace'
        expect(Process).to receive(:spawn).with(command).and_return(38)
        subject.start
      end
    end
  end
end
