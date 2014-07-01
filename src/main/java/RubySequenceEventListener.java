import org.activiti.engine.delegate.*;
import org.jruby.Ruby;
import org.jruby.RubyObject;
import org.jruby.runtime.Helpers;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.javasupport.JavaUtil;
import org.jruby.RubyClass;
import org.jruby.runtime.builtin.IRubyObject;

public class RubySequenceEventListener extends RubyObject implements ExecutionListener {
    private static final Ruby __ruby__ = Ruby.getGlobalRuntime();
    private static final RubyClass __metaclass__;

    private final IRubyObject world;

    static {
        String source = new StringBuilder("class RubySequenceEventListener\n" +
            "end\n" +
            "").toString();
        __ruby__.executeScript(source, "ruby_event_listener.rb");
        RubyClass metaclass = __ruby__.getClass("RubySequenceEventListener");
        if (metaclass == null) throw new NoClassDefFoundError("Could not load Ruby class: RubySequenceEventListener");
        metaclass.setRubyStaticAllocator(RubySequenceEventListener.class);
        __metaclass__ = metaclass;
    }

    private RubySequenceEventListener(Ruby ruby, RubyClass metaclass) {
        super(ruby, metaclass);
	__ruby__.getLoadService().require( "world.rb" );
	world = __ruby__.evalScriptlet( "World.new" );
    }

    public static IRubyObject __allocate__(Ruby ruby, RubyClass metaClass) {
        return new RubySequenceEventListener(ruby, metaClass);
    }

    public RubySequenceEventListener() {
        this(__ruby__, __metaclass__);
	Helpers.invoke(__ruby__.getCurrentContext(), this, "initialize");
  }

    
    public Object notify(Object execution) {
        IRubyObject ruby_arg_execution = JavaUtil.convertJavaToRuby(__ruby__, execution);
        IRubyObject ruby_result = Helpers.invoke(__ruby__.getCurrentContext(), this, "notify", ruby_arg_execution);
        return (Object)ruby_result.toJava(Object.class);

    }

  public void notify(DelegateExecution execution) throws Exception {
    System.out.println("in ruby activity listener");
    world.callMethod( __ruby__.getCurrentContext(), "say_hello" );
  }
}
