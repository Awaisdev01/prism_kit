---
name: prism-kit-ai-chat
description: >-
  Use when the user is building AI chat features with prism_kit: streaming
  clients (OpenAI-compatible, Anthropic, Gemini), AiChatView, tool calling,
  or the prism_ai event model. Ensures correct controller/stream wiring and
  the event-handling pattern for streaming UIs.
---

# Prism Kit AI Chat

## Guidelines

* ALWAYS drive chat UI through `AiChatController` (a `ChangeNotifier`) and
  render with `AiChatView(controller: ...)`. Never try to own the message
  list yourself — the controller exposes `sendUserMessage`,
  `appendAssistantDelta`, `finishAssistant`, and `reportError`.
* Use `OpenAiStreamClient` for OpenAI, Azure, Ollama (`/v1`), Groq, DeepSeek,
  Together, LM Studio and vLLM — one implementation covers the whole
  `/chat/completions` protocol family. Use `AnthropicStreamClient` for
  Claude and `GeminiStreamClient` for Gemini.
* Handle stream events with an `is` check per event type:
  `AiTextDelta` → `controller.appendAssistantDelta(event.text)`, then
  `controller.finishAssistant()` when the stream completes.
* Define tools with `AiTool(name:, description:, parametersSchema:,
  execute:)` and pass them into the client/agent. `execute` receives parsed
  arguments and returns the string the model should see; non-string values
  are JSON-encoded automatically.
* Prefer `AiAgent` (automatic tool-calling loop over any `AiStreamClient`)
  over hand-rolled request loops.
* NEVER hardcode API keys. Accept them through configuration or environment.
* Do not rebuild `AiChatView` per stream event — the controller notifies; the
  view listens.

## Examples

### Streamed chat end to end

```dart
import 'package:material_ui/material_ui.dart';
import 'package:prism_kit/prism.dart';

final controller = AiChatController();

Future<void> ask(String question) async {
  final client = OpenAiStreamClient(
    baseUrl: 'https://api.openai.com/v1',
    apiKey: 'sk-...', // from secure config, never committed
  );
  controller.sendUserMessage(question);
  final events = client.streamChat(
    controller.messages.map(
      (m) => ChatMessage(role: m.role, content: m.content),
    ),
    model: 'gpt-4o',
  );
  await for (final event in events) {
    if (event is AiTextDelta) {
      controller.appendAssistantDelta(event.text);
    }
  }
  controller.finishAssistant();
}
```

### Ready-made UI

```dart
AiChatView(controller: controller)
```

### Defining a tool

```dart
final weatherTool = AiTool(
  name: 'get_weather',
  description: 'Get current weather for a city',
  parametersSchema: {
    'type': 'object',
    'properties': {
      'city': {'type': 'string'},
    },
    'required': ['city'],
  },
  execute: (args) async => 'Sunny, 25°C in ${args['city']}',
);
```
