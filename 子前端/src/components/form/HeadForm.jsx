import { defineComponent } from 'vue';

export default defineComponent({
  props: {
    headerWidth: {
      type: String,
      default: '380px'
    }
  },
  setup(prop, { slots }){
    return () => (
      <div className="flex" style={{ alignItems: 'flex-start' }}>
        <ElForm inline={ true } class="cardHeaderFrom" style={{ width: prop.headerWidth }}>
          { slots.left() }
        </ElForm>
        <div className='flex flex-1' style={{ border: '1px solid rgba(0,0,0,.3)', alignItems: 'flex-start', padding: '10px 0 0 10px', borderRadius: '10px', boxShadow: "0 2px 1px 0 rgba(0,0,0,0.25)" }}>
          <ElForm inline={ true } labelWidth="90" class="cardHeaderFrom">
            { slots.center() }
          </ElForm>
          <ElForm inline={ true } class="cardHeaderFrom">
            { slots.right() }
          </ElForm>
        </div>
      </div>
    )
  }
});