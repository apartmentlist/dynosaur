describe Dynosaur::Process::Heroku do
  describe '#running?' do
    subject { Dynosaur::Process::Heroku.new(task: 'fake:task', args: %w[foo bar]) }

    let(:response) { [true, false].sample }
    let(:finder) do
      instance_double(Dynosaur::Process::Heroku::Finder, exists?: response)
    end

    before do
      rake_command =
        Dynosaur::Utils::RakeCommand.new(task: 'fake:task', args: %w[foo bar])
      allow(Dynosaur::Process::Heroku::Finder).to receive(:new)
        .with(rake_command: rake_command).and_return(finder)
    end

    it 'returns the value from Finder#exists?' do
      expect(subject.running?).to eq(finder.exists?)
    end
  end

  describe '#start' do
    subject { Dynosaur::Process::Heroku.new(task: task, args: args, opts: opts) }

    let(:task) { 'fake:task' }
    let(:args) { [] }
    let(:opts) { {} }

    let(:client) { instance_double(PlatformAPI::Client, dyno: dyno_accessor) }
    let(:dyno_accessor) { instance_double(PlatformAPI::Dyno, create: api_response) }

    let(:api_response) { { 'name' => 'run.9876' } }

    before do
      allow(PlatformAPI).to receive(:connect_oauth).with('dynosaur-test-key')
        .and_return(client)
    end

    it 'invokes dyno.create with the rake task' do
      command = 'rake fake:task --trace'
      expect(dyno_accessor).to receive(:create)
        .with('dynosaur-test-app', command: command, attach: false)
        .and_return(api_response)
      subject.start
    end

    it 'returns the dyno identifier' do
      expect(subject.start).to eq('run.9876')
    end

    context 'when args are passed to the rake task' do
      let(:args) { ['Hello World', 1999] }

      it 'adds the arguments to the rake task' do
        command = 'rake fake:task[Hello\\ World,1999] --trace'
        expect(dyno_accessor).to receive(:create)
          .with('dynosaur-test-app', command: command, attach: false)
          .and_return(api_response)
        subject.start
      end
    end

    context 'when dyno size is specified' do
      let(:opts) { { size: 'big' } }

      it 'includes the dyno size' do
        command = 'rake fake:task --trace'
        expect(dyno_accessor).to receive(:create)
          .with('dynosaur-test-app', command: command, attach: false, size: 'big')
          .and_return(api_response)
        subject.start
      end
    end

    context 'when attach is specified' do
      let(:opts) { { attach: true } }

      it 'includes the attach setting' do
        command = 'rake fake:task --trace'
        expect(dyno_accessor).to receive(:create)
          .with('dynosaur-test-app', command: command, attach: true)
          .and_return(api_response)
        subject.start
      end
    end
  end
end
