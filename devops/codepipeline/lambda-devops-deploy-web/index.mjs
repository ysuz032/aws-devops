import { CodePipelineClient, PutJobSuccessResultCommand, PutJobFailureResultCommand } from "@aws-sdk/client-codepipeline";
import { CloudFrontClient, CreateInvalidationCommand } from "@aws-sdk/client-cloudfront";

const codepipeline = new CodePipelineClient();
const cloudfront = new CloudFrontClient();

/**
 * Notify CodePipeline of a successful job
 * @param {Object} context - The Lambda context object
 * @param {string} jobId - The ID of the CodePipeline job
 * @param {string} message - The success message
 */
const putJobSuccess = async (context, jobId, message) => {
    const command = new PutJobSuccessResultCommand({
        jobId: jobId
    });
    try {
        await codepipeline.send(command);
        context.succeed(message);
    } catch (err) {
        context.fail(err);
    }
};

/**
 * Notify CodePipeline of a failed job
 * @param {Object} context - The Lambda context object
 * @param {string} jobId - The ID of the CodePipeline job
 * @param {string} message - The failure message
 */
const putJobFailure = async (context, jobId, message) => {
    const command = new PutJobFailureResultCommand({
        jobId: jobId,
        failureDetails: {
            message: JSON.stringify(message),
            type: 'JobFailed',
            externalExecutionId: context.awsRequestId
        }
    });
    try {
        await codepipeline.send(command);
        context.fail(message);
    } catch (err) {
        context.fail(err);
    }
};

/**
 * Create a CloudFront invalidation
 * @param {string} distributionId - The CloudFront distribution ID
 */
const createInvalidation = async (distributionId) => {
    try {
        const command = new CreateInvalidationCommand({
            DistributionId: distributionId,
            InvalidationBatch: {
                CallerReference: `invalidate-${Date.now()}`,
                Paths: {
                    Quantity: 1,
                    Items: ['/*'],
                },
            },
        });
        await cloudfront.send(command);
    } catch (error) {
        throw new Error(`Failed to create invalidation for distribution ${distributionId}: ${error.message}`);
    }
};

/**
 * Lambda function handler
 * @param {Object} event - The Lambda event object
 * @param {Object} context - The Lambda context object
 */
export const handler = async (event, context) => {
    // Retrieve the Job ID from the Lambda action
    const jobId = event["CodePipeline.job"].id;

    // Retrieve the value of UserParameters from the Lambda action configuration in CodePipeline
    const userParameters = JSON.parse(event["CodePipeline.job"].data.actionConfiguration.configuration.UserParameters);
    const { distributionId } = userParameters;

    try {
        // Validate the parameters
        if (!distributionId) {
            throw new Error('distributionId is a required parameter.');
        }

        // Create the CloudFront invalidation
        await createInvalidation(distributionId);

        // Succeed the job
        await putJobSuccess(context, jobId, "CloudFront invalidation created successfully.");
    } catch (error) {
        // Fail the job
        await putJobFailure(context, jobId, error.message);
    }
};