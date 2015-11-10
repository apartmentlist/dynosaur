describe Dynosaur::Process::Heroku do
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
  end
end
