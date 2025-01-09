# AWS-Re-architecture

This project was done to learn about how to re-architecture infrastructures instead of re-hosting them using lift and shift.
Inital infrasture had a producer spitting data to a monolithic application that processes and stores data to an on premise server. However they faced issues in scaling their operations.
Two approaches were taken one being lift and shift and hosting each component of the infrasture on the cloud instance and the other being to re-architecutre the entire infrastrucutre.

Solution one is simple however issues arrive in upkeep in adding new parts. Solution two requires more time however will scale and is easier to maintain due to everything being fully serverless.

Producer will spit data to a kinesis data stream which will then shard the data into two kinesis firehose streams. One leading to opensearch for analystics and the other going to s3 for storing the data.  AWS glue crawler is then run on the s3 bucket to do ELT operations for querying on AWS Athena 
