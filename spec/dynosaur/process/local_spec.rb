describe Dynosaur::Process::Local do
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
      let(:args) { ['Hello, World', 1999] }

      it 'adds the arguments to the rake task' do
        command = 'rake fake:task["Hello, World",1999] --trace'
        expect(Process).to receive(:spawn).with(command).and_return(38)
        subject.start
      end
    end
  end
end
