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
      <div class="flex" style={{ alignItems: 'flex-start' }}>
        {
          slots.left ? 
          <ElForm class="mt10" inline={ true } class="cardHeaderFrom" style={{ width: prop.headerWidth }}>
            { slots.left() }
          </ElForm> : <></>
        }
        {
          slots.center ? 
          <div class='flex flex-1' style={{ border: '1px solid rgba(0,0,0,.3)', alignItems: 'flex-start', padding: '10px 0 0 10px', borderRadius: '10px', boxShadow: "0 2px 1px 0 rgba(0,0,0,0.25)" }}>
            <ElForm inline={ true } labelWidth="90" class="cardHeaderFrom">
              { slots.center && slots.center() }
            </ElForm>
            <ElForm inline={ true } class="cardHeaderFrom">
              { slots.right && slots.right() }
            </ElForm>
          </div> : <></>
        }
      </div>
    )
  }
});