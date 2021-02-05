import { useBackend } from '../backend';
import { Button, Flex, Section, Box, Icon } from '../components';
import { Window } from '../layouts';

export const TechNode = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    total_points, unlocked, theme,
    cost, name, desc,
  } = data;

  return (
    <Window
      width={500}
      height={300}
      theme={theme}
    >
      <Window.Content>
        <Flex direction="column" height="100%">
          <Flex.Item grow={1}>
            <Section title="Information">
              <Flex direction="column">
                <Flex.Item>
                  <Label label="Name" content={name} />
                </Flex.Item>
                <Flex.Item mt={1}>
                  <Label label="Description" content={desc} />
                </Flex.Item>
                <Flex.Item mt={1}>
                  <Label label="Cost" content={cost} />
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
          <Flex.Item mt={1}>
            <Section>
              <Label label="Current Points" content={cost} />
              <Flex mt={1}>
                <Flex.Item grow={1}>
                  {!!unlocked && (
                    <Box
                      textAlign="center"
                      className="TechNode__purchased"
                      width="100%"
                      backgroundColor="green"
                    >
                      Purchased
                    </Box>
                  ) || (
                    <Button
                      content="Purchase"
                      textAlign="center"
                      fluid
                      height="100%"
                      icon="shopping-cart"
                      color={total_points >= cost? "good" : "bad"}
                      onClick={() => act("purchase")}
                    />
                  )}
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const Label = (props, context) => {
  const { label, content, ...rest } = props;

  return (
    <Flex {...rest}>
      <Flex.Item width="25%">
        <Box color="label">{label}:</Box>
      </Flex.Item>
      <Flex.Item width="75%">
        <Box className="TechNode__content">{content}</Box>
      </Flex.Item>
    </Flex>
  );
};
