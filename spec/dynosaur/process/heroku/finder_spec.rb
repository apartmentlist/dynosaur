describe Dynosaur::Process::Heroku::Finder do
  subject do
    Dynosaur::Process::Heroku::Finder.new(rake_command: rake_command, client: client)
  end

  let(:client) { instance_double(PlatformAPI::Client, dyno: dyno_accessor) }
  let(:dyno_accessor) { instance_double(PlatformAPI::Dyno) }

  before do
    allow(dyno_accessor).to receive(:list).with('dynosaur-test-app')
      .and_return(dynos)
  end

  describe '#exists?' do
    context 'when the command has no args' do
      let(:rake_command) { Dynosaur::Utils::RakeCommand.new(task: 'fake:task') }

      context 'and it is running' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task' }]
        end

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with a rake flag' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task --trace' }]
        end

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with args' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task[foo]' }]
        end

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end

      context 'and it is running a namespaed task' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task:bar' }]
        end

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end

      context 'and it is not running' do
        let(:dynos) { [] }

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end
    end

    context 'when the command has args' do
      let(:rake_command) do
        Dynosaur::Utils::RakeCommand.new(task: 'fake:task', args: ['foo'])
      end

      context 'and it is running without args' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task' }]
        end

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end

      context 'and it is running with the same args' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task[foo]' }]
        end

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with the same args and a rake flag' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task[foo] --trace' }]
        end

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with the different args' do
        let(:dynos) do
          [{ 'type' => 'run', 'command' => 'bundle exec rake fake:task[bar]' }]
        end

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end
    end
  end
end
