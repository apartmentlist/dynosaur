describe Dynosaur::Process::Local::Finder do
  subject { Dynosaur::Process::Local::Finder.new(rake_command: rake_command) }

  before do
    allow(Dynosaur::Utils::OS).to receive(:structured_ps)
      .and_return(processes)
  end

  describe '#exists?' do
    let(:processes) { [Struct.new(:command).new(running_command)] }

    context 'when the command has no args' do
      let(:rake_command) { Dynosaur::Utils::RakeCommand.new(task: 'fake:task') }

      context 'and it is running' do
        let(:running_command) { 'rake fake:task' }

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with a rake flag' do
        let(:running_command) { 'rake fake:task --trace' }

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with args' do
        let(:running_command) { 'rake fake:task[foo]' }

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end

      context 'and it is running a namespaced task' do
        let(:running_command) { 'rake fake:task:bar' }

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end

      context 'and it is not running' do
        let(:processes) { [] }

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
        let(:running_command) { 'rake fake:task' }

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end

      context 'and it is running with the same args' do
        let(:running_command) { 'rake fake:task[foo]' }

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with the same args and a rake flag' do
        let(:running_command) { 'rake fake:task[foo] --trace' }

        it 'returns true' do
          expect(subject.exists?).to eq(true)
        end
      end

      context 'and it is running with the different args' do
        let(:running_command) { 'rake fake:task[bar]' }

        it 'returns false' do
          expect(subject.exists?).to eq(false)
        end
      end
    end
  end
end
