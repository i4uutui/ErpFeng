import { defineComponent, ref } from "vue";

export default defineComponent({
	setup() {
		return () => (
			<>
				<ElCard style={{ height: "100%" }}>
					<ElTimeline style="max-width: 600px">
						<ElTimelineItem timestamp='2025-11-01' placement="top">
              <ElCard>
                <h4>首次上线</h4>
                {/* <p>Tom committed 2018/4/12 20:46</p> */}
              </ElCard>
            </ElTimelineItem>
            <ElTimelineItem timestamp='结束' placement="top">
            </ElTimelineItem>
					</ElTimeline>
				</ElCard>
			</>
		);
	},
});
