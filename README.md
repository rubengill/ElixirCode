# Elixir Code

The following is a collection of problems and exercises solved in Elixir, demonstrating core concepts in concurrent programming. 

**Elixir 1.17.2 | Erlang/OTP 27**

# 01: RSA Cryptography Fundamentals

Implementation of core mathematical functions used in RSA encryption/decryption:

- **`mod_inverse/2`** - Extended Euclidean algorithm to find multiplicative inverse modulo n
- **`mod_pow/3`** - Fast modular exponentiation using binary exponentiation to handle large numbers efficiently

These functions demonstrate foundational cryptographic operations and efficient algorithms for handling large integer arithmetic in Elixir.

# 02: Binary Manipulation & Taylor Series

- **`reverse_bytes/1`** - Manual binary reversal without library functions
- **`sine_stream/1`** - Lazy stream implementation of Taylor series for sine function  
- **`sin/1`** - Accurate sine calculation using series convergence with period reduction

Demonstrates binary pattern matching, mathematical series implementation, and stream processing in Elixir.

# 03: GenServer Applications

Two GenServer implementations demonstrating different OTP patterns:

**Card.Server**
- **Unregistered GenServer** - Card deck management with PID-based API
- **State persistence** - Tracks remaining cards across operations
- **Mix project structure** - Proper Elixir application organization

**Arith.Server + Arith.Worker** 
- **Worker pool pattern** - Round-robin request dispatching
- **Registered server** - Single entry point managing multiple workers
- **Concurrent processing** - Non-blocking operations across worker processes

Demonstrates advanced GenServer patterns, process supervision, and concurrent system design.

# 04: Supervision & Fault Tolerance

Advanced OTP patterns with supervision trees and state persistence:

**Card.Worker + Card.Store**
- **Supervised GenServer** - Automatic restart with state recovery
- **State persistence** - File-based storage (`cards.db`) survives crashes
- **Fault tolerance** - Intentional crashes on invalid input for testing
- **OTP Supervisor** - Created with `--sup` flag

**Enhanced Arith.Server**
- **Process monitoring** - Server tracks worker health without polling
- **Dynamic supervision** - Automatic worker replacement on failure
- **Fault injection** - Crashes on non-numeric input for testing supervision

Demonstrates production-ready OTP applications with supervision, monitoring, and state recovery patterns.

# 05: Dynamic Supervision & Process Registry

Production-grade OTP application with dynamic worker management:

**Card.WorkerSupervisor**
- **DynamicSupervisor** - Runtime worker creation and management
- **Process Registry** - Named worker lookup via `Card.Registry`
- **ETS state storage** - Persistent state across worker restarts (`Card.Store`)

**Enhanced Card.Worker**
- **Registry integration** - Workers registered by name, not PID
- **State recovery** - Automatic state restoration from ETS on restart
- **Fault injection** - Crashes on invalid input for supervision testing

**Application Supervision Tree**
- **Multi-tier supervision** - Registry → DynamicSupervisor → Workers
- **OTP Application** - Proper startup sequence and dependency management

Demonstrates enterprise Elixir architecture with dynamic processes, state persistence, and fault-tolerant design patterns used in production systems.

# 06: TCP Echo Servers - Socket Mode Comparison

Three TCP server implementations demonstrating different socket handling strategies:

**ActiveEchoServer**
- **Active mode** (`active: true`) - Messages delivered automatically to process mailbox
- **Message-driven** - Uses `receive` pattern matching for incoming data
- **High throughput** - No blocking calls, but potential mailbox flooding

**PassiveEchoServer** 
- **Passive mode** (`active: false`) - Explicit `recv` calls required
- **Blocking I/O** - Synchronous data reading with error handling
- **Flow control** - Prevents message queue overflow

**HybridEchoServer**
- **Hybrid mode** (`active: :once`) - Single message delivery, then switches to passive
- **Balanced approach** - Combines benefits of both modes
- **Optimal control** - Manual reactivation after processing each message

Demonstrates low-level network programming patterns and socket management strategies in Elixir/Erlang.
